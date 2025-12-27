
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


# If you created the VPC/subnet manually in AWS, import it logically:

data "aws_subnet" "jenkins" {
  id = "subnet-01a62adfcf85ac2be"
}
