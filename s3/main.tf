terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}



resource "aws_s3_bucket" "s3Bucket" {
   bucket = var.bucket_name_data
   acl = "private"
   tags = {
     Name = "Created using terraform"
        }
}

resource "aws_s3_bucket" "s3Bucket2" {
   bucket = var.bucket_name_dag
   acl = "private"
   tags = {
     Name = "Created using terraform"
        }
}

resource "aws_iam_policy" "bucket_rw_policy" {
  name        = "zoomcamp_s3_rw_policy"
  path        = "/"
  description = "Allow rw access to S3"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "bucket_read_policy" {
  name        = "zoomcamp_s3_read_policy"
  path        = "/"
  description = "Allow read access to s3 "
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : ["s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource" : [
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}
