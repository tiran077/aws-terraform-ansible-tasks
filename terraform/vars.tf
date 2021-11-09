variable "ami" {
  description = "Ubuntu AMI"
  default     = "ami-083654bd07b5da81d"
}

variable "az" {
  type    = string
  default = "us-east-1a"
}

variable "ec2_type" {
  type    = string
  default = "t2.small"
}

variable "ssh-key" {
  type    = string
  default = "demo-key"
}

variable "projet" {
  type    = string
  default = "task"
}

variable "ebs_type" {
  type    = string
  default = "gp2"
}

variable "ec2_nb" {
  default = "3"
}
