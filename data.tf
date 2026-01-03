
data "aws_ami" "joindevops" {

  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


data "aws_ami" "sonarqube" {
  most_recent = true
  owners      = ["679593333241"] # Solve DevOps

  filter {
    name   = "name"
    values = ["SolveDevOps-SonarQube-Server-Ubuntu24.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


#to get default vp
data "aws_vpc" "default_vpc" {
  default = true

  # Optional: Add a second filter just to be explicit
  filter {
    name   = "is-default"
    values = ["true"]
  }
}

#to get default subnet
data "aws_subnet" "default_subnet" {
  vpc_id            = data.aws_vpc.default_vpc.id
  default_for_az    = true
  availability_zone = "us-east-1a"
}

#to get default security group
data "aws_security_group" "default_sg" {
  vpc_id = data.aws_vpc.default_vpc.id

  # The filter targets the SG named 'default' in the VPC.
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

