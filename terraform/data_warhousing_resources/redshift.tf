/*
# When deploying in a new environment, the below local variables need to be commented as they are dependent on the deployment of 
# data-platform-services-redshift-ddl and data-platform-services-redshift-copy-jobs
locals {
    ddl_lambda_security_group_id          = data.tfe_outputs.data_platform_services_redshift_ddl.values.lambda_security_group_id
    copy_jobs_lambda_security_group_id    = data.tfe_outputs.data_platform_services_redshift_copy_jobs.values.lambda_security_group_id
}

#KMS used for the redshift cluster encryption
module "redshift_kms_key" {
  source                   = "app.terraform.io/dummy/kms/aws"
  version                  = "0.0.12"
  description              = "This kms key is used for encrypting redshift cluster"
  enable_key_rotation      = true
  kms_key_admin_principals = var.redshift_kms_key_admin_principals
  kms_key_usage_principals = var.redshift_kms_key_usage_principals
  alias_name               = var.redshift_kms_key_alias_name
  name                     = var.redshift_kms_key_alias_name
  owner                    = var.owner
  env                      = var.env
}

# Redshift subnet group
resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name = var.redshift_subnet_group_name
  subnet_ids = [
    module.private_subnet_1.subnet_id,
    module.private_subnet_2.subnet_id
  ]
  tags = {
    Name        = var.redshift_subnet_group_name
    Owner       = var.owner
    Environment = var.env
    Region      = var.aws_region
  }
}
# Security group
module "redshift_security_group" {
  source      = "app.terraform.io/dummy/security-group/aws"
  version     = "0.0.5"
  description = "Security group for redshift cluster"
  vpc_id      = module.vpc.vpc_id
  security_group_self_rules = [{
    type      = "ingress"
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true

  }]
  security_group_cidr_block_rules = [{
    type             = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
  ]
# When deploying in a new environment, the two security group rules below need to be commented as they are dependent on the deployment of 
# data-platform-services-redshift-ddl and data-platform-services-redshift-copy-jobs
  security_group_source_sg_rules = [
    {
      type             = "ingress"
      from_port        = 5439
      to_port          = 5439
      protocol         = "tcp"
      source_security_group_id = local.ddl_lambda_security_group_id
    },
    {
      type             = "ingress"
      from_port        = 5439
      to_port          = 5439
      protocol         = "tcp"
      source_security_group_id = local.copy_jobs_lambda_security_group_id
    },
    {
      type             = "ingress"
      from_port        = 5439
      to_port          = 5439
      protocol         = "tcp"
      source_security_group_id = module.bastion_host.security_group_id
    }
  ]
  name       = var.redshift_security_group_name
  env        = var.env
  aws_region = var.aws_region
  owner      = var.owner
}

# fetch redshift secret
data "aws_secretsmanager_secret" "redshift_secret" {
  name = var.redshift_secret_name
}

data "aws_secretsmanager_secret_version" "redshift_secret" {
  secret_id = data.aws_secretsmanager_secret.redshift_secret.id
}

locals {
  redshift_credentials = jsondecode(data.aws_secretsmanager_secret_version.redshift_secret.secret_string)
}

# redshift cluster
resource "aws_redshift_cluster" "redshift_cluster" {
  lifecycle {
    prevent_destroy = true
  }
  cluster_identifier = var.redshift_cluster_name
  master_username    = local.redshift_credentials["username"]
  master_password    = local.redshift_credentials["password"]
  port               = var.redshift_port
  database_name      = var.redshift_database_name
  node_type          = var.redshift_node_type
  cluster_type       = var.redshift_cluster_type
  number_of_nodes    = var.redshift_number_of_nodes
  availability_zone  = var.redshift_availability_zone
  iam_roles          = [aws_iam_role.redshift_role.arn]

  # Snapshots and Backups
  automated_snapshot_retention_period = var.redshift_snapshot_retention_period
  final_snapshot_identifier           = var.final_snapshot_identifier
  preferred_maintenance_window        = var.redshift_preferred_maintenance_window

  #checkov:skip=CKV_AWS_141:major version upgrade is disabled
  allow_version_upgrade               = false  # If false, it does not perform major version upgrades
  skip_final_snapshot                 = false

  # Encryption
  encrypted  = true
  kms_key_id = module.redshift_kms_key.arn

  # VPC configs
  vpc_security_group_ids    = [module.redshift_security_group.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.id
  publicly_accessible       = false
  enhanced_vpc_routing      = true

  # Logging
  logging {
    enable        = true
    bucket_name   = module.redshift_logs_s3_bucket.s3_bucket_id
    s3_key_prefix = "redshift/"
  }
  depends_on = [
    aws_s3_bucket_policy.redshift_logs_s3_bucket_policy
  ]
  # Parameter group
  cluster_parameter_group_name  = aws_redshift_parameter_group.redshift_parameter_group.id

  #tags
  tags = {
    Name        = var.redshift_cluster_name
    Owner       = var.owner
    Environment = var.env
    Region      = var.aws_region
  }
}

#Adding redshift details to secret manager
resource "aws_secretsmanager_secret_version" "redshift_secret_version" {
  secret_id     = data.aws_secretsmanager_secret.redshift_secret.id
  secret_string = <<EOF
   {
    "engine": "redshift",
    "host": "${aws_redshift_cluster.redshift_cluster.endpoint}",
    "username": "${local.redshift_credentials["username"]}",
    "password": "${local.redshift_credentials["password"]}",
    "dbname": "${aws_redshift_cluster.redshift_cluster.database_name}",
    "port": "${aws_redshift_cluster.redshift_cluster.port}"
   }
EOF
}

# Redshift Audit bucket
module "redshift_logs_s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~>2.15.0"
  bucket  = var.redshift_s3_bucket_logs
  acl     = "log-delivery-write"
  versioning = {
    enabled = true
  }

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  # https://docs.aws.amazon.com/redshift/latest/mgmt/db-auditing.html
  # Currently, AWS supports Amazon S3-managed keys (SSE-S3) encryption (AES-256) for audit logging.
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = false
    }
  }
  tags = {
    Name        = var.redshift_s3_bucket_logs
    Owner       = var.owner
    Environment = var.env
    Region      = var.aws_region
  }

}

# Attaching Bucket Policy to Redshift Access logs S3 bucket
resource "aws_s3_bucket_policy" "redshift_logs_s3_bucket_policy" {
  bucket = module.redshift_logs_s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.redshift_logs_s3_bucket_policy.json
}


data "aws_iam_policy_document" "redshift_logs_s3_bucket_policy" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    principals {
      identifiers = [
        "redshift.amazonaws.com"
      ]
      type = "Service"
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:PutObject"
    ]
    resources = [
      "${module.redshift_logs_s3_bucket.s3_bucket_arn}",
      "${module.redshift_logs_s3_bucket.s3_bucket_arn}/*"
    ]
  }
  #statement denying deletion action for everyone
  statement {
    sid    = "S3DeletionPolicy"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:DeleteBucket"
    ]
    resources = [
      module.redshift_logs_s3_bucket.s3_bucket_arn
    ]
  }
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"
    principals {
      identifiers = [
        "*"
      ]
      type = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      module.redshift_logs_s3_bucket.s3_bucket_arn,
      "${module.redshift_logs_s3_bucket.s3_bucket_arn}/*"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        false
      ]
    }
  }
}

# Redshift parameter group
resource "aws_redshift_parameter_group" "redshift_parameter_group" {
  name   = var.redshift_parameter_group_name

  # At this time, redshift-1.0 is the only version of the Amazon Redshift engine.
  # https://docs.aws.amazon.com/redshift/latest/mgmt/working-with-parameter-groups.html
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "require_ssl"
    value = "true"
  }

  tags = {
    Name        = var.redshift_parameter_group_name
    Owner       = var.owner
    Environment = var.env
    Region      = var.aws_region
  }
}

# Redshift snapshot schedule
resource "aws_redshift_snapshot_schedule" "redshift_snapshot_schedule" {
  identifier = var.redshift_snapshot_schedule_identifier
  description = "This takes snapshot of redshift cluster in every 12 hours"
  definitions = [
    var.redshift_snapshot_schedule_rate
  ]

  tags = {
    Name        = var.redshift_snapshot_schedule_identifier
    Owner       = var.owner
    Environment = var.env
    Region      = var.aws_region
  }
}

# Associating snapshot schedule to redshift cluster
resource "aws_redshift_snapshot_schedule_association" "snapshot_schedule_association" {
  cluster_identifier  = aws_redshift_cluster.redshift_cluster.id
  schedule_identifier = aws_redshift_snapshot_schedule.redshift_snapshot_schedule.id
}

*/