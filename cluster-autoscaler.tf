resource "aws_iam_policy" "cluster_autoscaler" {

  name = "${var.eks_name}-cluster-autoscaler"

  policy = file("${path.module}/iam/cluster-autoscaler-policy.json")
}

resource "aws_iam_role" "cluster_autoscaler" {

  name = "${var.eks_name}-cluster-autoscaler"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{

      Effect = "Allow"

      Principal = {

        Service = "pods.eks.amazonaws.com"

      }

      Action = [
        "sts:AssumeRole",
        "sts:TagSession"
      ]

    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {

  role = aws_iam_role.cluster_autoscaler.name

  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "autoscaling-aws-cluster-autoscaler"
  role_arn        = aws_iam_role.cluster_autoscaler.arn
}
