resource "aws_iam_policy" "aws_lb_controller" {
  name        = "${var.eks_name}-aws-lb-controller"
  description = "AWS Load Balancer Controller Policy"

  policy = file("${path.module}/iam/AWSLoadBalancerController.json")
}

resource "aws_iam_role" "aws_lb_controller" {
  name = "${var.eks_name}-aws-lb-controller"

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


resource "aws_iam_role_policy_attachment" "aws_lb_controller" {

  role       = aws_iam_role.aws_lb_controller.name

  policy_arn = aws_iam_policy.aws_lb_controller.arn
}

resource "aws_eks_pod_identity_association" "aws_lb_controller" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_lb_controller.arn
}