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



resource "aws_iam_role" "zoomcamp_lambda_exec_role_download" {
  name = "zoomcamp_lambda_exec_role_download"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}


data "aws_iam_policy" "policy_name_s3" {
  name = "zoomcamp_s3_rw_policy"
}


resource "aws_iam_role_policy_attachment" "s3_read_write" {
  role = aws_iam_role.zoomcamp_lambda_exec_role_download.name
  policy_arn = "${data.aws_iam_policy.policy_name_s3.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_download.name
}

resource "aws_iam_role_policy_attachment" "secrets_manager" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_download.name
}




resource "aws_iam_role" "zoomcamp_lambda_exec_role_unzip" {
  name = "zoomcamp_lambda_exec_role_unzip"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_write2" {
  role = aws_iam_role.zoomcamp_lambda_exec_role_unzip.name
  policy_arn = "${data.aws_iam_policy.policy_name_s3.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda2" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_unzip.name
}

resource "aws_iam_role_policy_attachment" "secrets_manager2" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_unzip.name
}



resource "aws_iam_role" "zoomcamp_lambda_exec_role_copy" {
  name = "zoomcamp_lambda_exec_role_copy"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

data "aws_iam_policy" "policy_name_s3_ro" {
  name = "zoomcamp_s3_read_policy"
}

resource "aws_iam_role_policy_attachment" "s3_read3" {
  role = aws_iam_role.zoomcamp_lambda_exec_role_copy.name
  policy_arn = "${data.aws_iam_policy.policy_name_s3_ro.arn}"
}

resource "aws_iam_role_policy_attachment" "lambda3" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_copy.name
}

resource "aws_iam_role_policy_attachment" "secrets_manager3" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.zoomcamp_lambda_exec_role_copy.name
}



#resource "aws_lambda_function" "lambda" {
#  function_name = "TripsDataDownLoad"
#  image_uri = var.image_uri
#  package_type = "Image"
#  role = "${aws_iam_role.zoomcamp_lambda_exec_role_download.arn}"
#  timeout = 300
#}
