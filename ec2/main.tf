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

resource "aws_security_group" "ec2-airflow-sg" {
  name        = "zoomcamp-ec2-airflow-sg"
  description = "Allow inbound traffic"
  
  ingress {
    description      = "8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ec2-airflow-sg"
  }
}


resource "aws_iam_role" "zoomcamp_ec2_role" {
  name        = "zoomcamp_ec2_role"
  description = "zoomcamp_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "policy_name_ref" {
  name = "zoomcamp_s3_read_policy"
}

resource "aws_iam_role_policy_attachment" "ec2_s3_access" {
  role       = aws_iam_role.zoomcamp_ec2_role.name
  policy_arn = "${data.aws_iam_policy.policy_name_ref.arn}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "iam_instance_profile"
  role = "${aws_iam_role.zoomcamp_ec2_role.name}"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0aa7d40eeae50c9a9"
  instance_type = "t2.medium"
  vpc_security_group_ids=["${aws_security_group.ec2-airflow-sg.id}"]#aws_security_group.ec2-airflow-sg.arn]
  iam_instance_profile ="${aws_iam_instance_profile.iam_instance_profile.name}"  #aws_iam_role.zoomcamp_ec2_role.name
  user_data = <<EOF
    #! /bin/bash
    sudo yum update -y
    sudo yum install docker -y
    sudo usermod -a -G docker $USER
    id $USER
    newgrp docker
    sudo yum install python3-pip
    sudo pip3 install docker-compose
    sudo systemctl enable docker.service
    sudo systemctl start docker.service
    cd ..
    cd ..
    sudo mkdir airflow-docker
    sudo chmod a+rwx airflow-docker
    cd airflow-docker
    curl -Lf0 'https://airflow.apache.org/docs/apache-airflow/stable/docker-compose.yaml' --output docker-compose.yaml
    mkdir ./dags ./plugins ./logs
    touch .env
    echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >  .env
    docker-compose up airflow-init
    docker-compose up
  EOF

  tags = {
    Name = var.instance_name
  }
}
