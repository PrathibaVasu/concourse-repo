
# Bucket Policy
data "aws_iam_policy_document" "staging_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [""]  #[aws_iam_role.glue_role.arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.staging_bucket_name}",
    ]
  }
}


data "aws_iam_policy_document" "integration_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [""]  #[aws_iam_role.glue_role.arn]
    }

    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${local.integration_bucket_name}",
    ]
  }
}



/*
resource "aws_iam_role" "glue_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "glue.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
*/