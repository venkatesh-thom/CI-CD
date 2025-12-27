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
  default     = "Z0289756D5X1LXL2LSE7"
  description = "description"
}

variable "sonar" {
  default = false
}

