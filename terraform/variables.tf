variable "aws_region" {
  description = "AWS region to deploy to"
  default     = "ap-south-1"
}

variable "project_name" {
  default = "cloudpilot"
}
variable "db_username" {
  description = "PostgreSQL DB username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL DB password"
  type        = string
  sensitive   = true
}
variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true
}
variable "aws_auth_users" {
  description = "List of IAM users to add to the aws-auth configmap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}


