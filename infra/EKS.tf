module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                            = var.cluster_name
  kubernetes_version              = "1.34"

  enable_cluster_creator_admin_permissions = true  
  
  endpoint_private_access = true
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    alura = {
      min_size     = 1
      max_size     = 10
      desired_size = 3
      vpc_security_group_ids = [aws_security_group.ssh_cluster.id]
      instance_types = ["t3.small"]
    }
  }
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  addon_version = "v1.18.0-eksbuild.1"
}