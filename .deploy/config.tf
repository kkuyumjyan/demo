terraform {
  required_version = ">= v0.14.5"
  backend "s3" {
    region               = "eu-central-1"
    bucket               = "example-co-terraform-states-primary"
    key                  = "demo-api/state.tfstate"
    workspace_key_prefix = "workspace"
    dynamodb_table       = "terraform-state-lock"
    encrypt              = true
  }
}

provider "aws" {
  region = var.region
}

data "aws_eks_cluster" "this" {
  name = lookup(var.eks_name, local.env)
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}
