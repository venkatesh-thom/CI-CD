variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "zone_name" {
  type        = string
  default     = "venkatesh.fun"
  description = "description"
}

variable "zone_id" {
  type        = string
  default     = "Z00574303OXB3420S598P"
  description = "description"
}

variable "sonar" {
  default = false
}

