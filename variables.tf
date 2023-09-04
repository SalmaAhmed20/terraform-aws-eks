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
variable "PRIV_SUBNET_ID1" {
  description = "Private subnet 1 id"
  type        = string
}
variable "PRIV_SUBNET_ID2" {
  description = "Private subnet 2 id"
  type        = string
}
variable "PUB_SUBNET_ID" {
  description = "Public subnet id"
  type        = string
}
variable "VPC_CIDR" {
  description = "CIDR Block of vpc"
  type        = string
}
variable "VPC_ID" {
  description = "VPC ID"
  type        = string
}
