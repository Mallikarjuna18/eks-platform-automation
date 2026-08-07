terraform {
  backend "s3" {
    bucket = "eks-cluster-backend-lucidity"
    key    = "terraform/eks.tfstate"
    region = "us-east-1"
  }
}
