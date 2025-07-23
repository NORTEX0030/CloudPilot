module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name    = var.cluster_name   # or "cloudpilot-eks" if hardcoded
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  enable_irsa = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    dev = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
    }
  }

  tags = {
    Environment = "dev"
    Project     = "cloudpilot"
  }
}
