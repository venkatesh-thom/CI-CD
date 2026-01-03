locals {
  #common_name_suffix = "${var.project_name}-${var.environment}"
  ami_id            = data.aws_ami.joindevops.id
  vpc_id            = data.aws_vpc.default_vpc.id
  sonar_ami_id      = data.aws_ami.sonarqube.id
  public_subnet_id  = data.aws_subnet.default_subnet.id
  security_group_id = data.aws_security_group.default_sg.id
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
