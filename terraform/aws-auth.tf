module "eks_aws_auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "20.8.3"

  manage_aws_auth_configmap = true
  aws_auth_users            = var.aws_auth_users
}
