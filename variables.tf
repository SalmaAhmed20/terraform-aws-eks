variable "eks_name" {
  description = "Name of Kubernetes Cluster on AWS"
  type        = string
}
variable "INSTANCE_TYPE" {
  type    = string
  default = "t2.small"
}
variable "AMI" {
  default = "ami-00aa9d3df94c6c354"
  type    = string
}