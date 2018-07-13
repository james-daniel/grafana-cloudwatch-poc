terraform {
  required_version = ">= 0.11.2"
}

resource "aws_instance" "aw2lp2" {
  ami           = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_size}"

  tags {
    Name = "ProdMon01"
  }
}

resource "aws_iam_policy" "aw2_metrics" {
  name        = "aw2_metrics"
  path        = "/"
  description = "IAM Policy for EC2 to CloudWatch"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "1",
          "Effect": "Allow",
          "Action": [
              "cloudwatch:PutMetricData",
              "cloudwatch:GetMetricStatistics",
              "cloudwatch:GetMetricData",
              "cloudwatch:ListMetrics"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_security_group" "aw2_metrics_sg" {
  name        = "aw2_metrics_sg"
  description = "Permit SSH IN from Admin WKS to EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["8.8.8.8/32"]
  }

  tags {
    Name = "allow_all"
  }
}
