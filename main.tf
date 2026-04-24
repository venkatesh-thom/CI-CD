
resource "aws_instance" "jenkins" {
  ami                    = local.ami_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = "subnet-0ad3a786fedff2a06" #replace your Subnet in default VPC
  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins.sh")
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

resource "aws_instance" "jenkins_agent" {
  ami                    = local.ami_id
  instance_type          = "t3.small"
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = "subnet-0ad3a786fedff2a06" #replace your Subnet in default VPC
  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  user_data = file("jenkins-agent.sh")
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-jenkins-agent"
    }
  )
}


# resource "aws_instance" "sonar" {
#   count                  = var.sonar ? 1 : 0
#   ami                    = data.aws_ami.rhel9.id
#   instance_type          = "t3.large"
#   vpc_security_group_ids = [aws_security_group.main.id]
#   subnet_id              = "subnet-01a62adfcf85ac2be"
#   #key_name               = "daws-86s"
#   iam_instance_profile = aws_iam_instance_profile.jenkins.name

#   root_block_device {
#     volume_size = 30
#     volume_type = "gp3"
#   }

#   user_data = file("sonar.sh")

#   tags = merge(
#     local.common_tags,
#     {
#       Name = "${var.project}-${var.environment}-sonar"
#     }
#   )
# }





resource "aws_security_group" "main" {
  name        = "${var.project}-${var.environment}-jenkins"
  description = "Created to attatch Jenkins and its agents"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-jenkins"
    }
  )
}

resource "aws_route53_record" "jenkins" {
  zone_id         = var.zone_id
  name            = "jenkins.${var.zone_name}"
  type            = "A"
  ttl             = 1
  records         = [aws_instance.jenkins.public_ip]
  allow_overwrite = true
}

# resource "aws_route53_record" "sonar" {
#   count           = var.sonar ? 1 : 0
#   zone_id         = var.zone_id
#   name            = "sonar.${var.zone_name}"
#   type            = "A"
#   ttl             = 1
#   records         = [aws_instance.sonar[0].public_ip]
#   allow_overwrite = true
# }

resource "aws_route53_record" "jenkins-agent" {
  zone_id         = var.zone_id
  name            = "jenkins-agent.${var.zone_name}"
  type            = "A"
  ttl             = 1
  records         = [aws_instance.jenkins_agent.private_ip]
  allow_overwrite = true
}


