variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "key_name" { type = string } # existing EC2 keypair name

variable "github_repo" {
  type        = string
  description = "HTTPS repo URL, e.g. https://github.com/minabisa/jenkins-cloud-lab.git"
}

variable "github_branch" {
  type    = string
  default = "main"
}
