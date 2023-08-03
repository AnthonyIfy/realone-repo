provider "kubernetes" {
    #load_config_file = "false"
    host = data.aws_eks_cluster.myapp1-cluster.endpoint
    token = data.aws_eks_cluster_auth.myapp1-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp1-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp1-cluster" {
    name = module.eks.cluster_id
}


data "aws_eks_cluster_auth" "myapp1-cluster" {
    name = module.eks.cluster_id
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.21.0"

  cluster_name = "myapp1-eks-cluster"  
  cluster_version = "1.22"

  subnet_ids = module.myapp1-vpc.private_subnets
  vpc_id = module.myapp1-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp1"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 4
      desired_size = 3

      instance_types = ["t2.small"]
      key_name       = "private-joy"
    }
  }
}
