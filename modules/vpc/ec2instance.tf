#----------------------------------------------------
## IAM Policies
## S3 Full Access
resource "aws_iam_policy" "ec2-policy" {
  name        = "nghi_policy"
  path        = "/"
  description = "full access to s3 bucket"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
  })
}

#----------------------------------------------------
## IAM Role
resource "aws_iam_role" "ec2-role" {
  name = "nghi_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

  tags = {
    tag-key = "nghi_role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.ec2-policy.arn
}
#----------------------------------------------------
## IAM Instance Profile
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2-role.name
}

#----------------------------------------------------
## AMI
data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

#----------------------------------------------------
## Security Group
resource "aws_security_group" "vpc-1-allow_icmp" {
  name        = "allow_icmp"
  description = "ICMP traffic from any address in the internal network"
  vpc_id      = aws_vpc.vpc_1.id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ICMP"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_icmp"
  }
}

resource "aws_security_group" "vpc-2-allow_icmp" {
  name        = "vpc-2-allow_icmp"
  description = "ICMP traffic from any address in the internal network"
  vpc_id      = aws_vpc.vpc_2.id

  ingress {
    description      = "ICMP"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_icmp"
  }
}

resource "aws_security_group" "vpc-3-allow_icmp" {
  name        = "vpc-3-allow_icmp"
  description = "ICMP traffic from any address in the internal network"
  vpc_id      = aws_vpc.vpc_3.id

  ingress {
    description      = "ICMP"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "vpc-3-allow_icmp"
  }
}
#----------------------------------------------------
## Instance
resource "aws_instance" "vpc_1_ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids = [aws_security_group.vpc-1-allow_icmp.id]
  subnet_id = aws_subnet.vpc_1_public_subnet.id
  associate_public_ip_address = true

  tags = {
    "Name" = "vpc-1-ec2"
  }
}
resource "aws_instance" "vpc_2_ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids = [aws_security_group.vpc-2-allow_icmp.id]
  subnet_id = aws_subnet.vpc_2_public_subnet.id

  tags = {
    "Name" = "vpc-2-ec2"
  }
}
resource "aws_instance" "vpc_3_ec2" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name
  vpc_security_group_ids = [aws_security_group.vpc-3-allow_icmp.id]
  subnet_id = aws_subnet.vpc_3_public_subnet.id

  tags = {
    "Name" = "vpc-3-ec2"
  }
}