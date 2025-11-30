data "aws_iam_policy_document" "aws_lbc_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole", "sts:TagSession"]
  }
}

data "http" "aws_lbc_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.16.0/docs/install/iam_policy.json"
}

resource "aws_iam_role" "aws_lbc" {
  name               = "${var.cluster_name}-aws-lbc"
  assume_role_policy = data.aws_iam_policy_document.aws_lbc_trust.json
}

resource "aws_iam_policy" "aws_lbc" {
  name   = "AWSLoadBalancerController"
  policy = data.http.aws_lbc_policy.response_body
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
  policy_arn = aws_iam_policy.aws_lbc.arn
  role       = aws_iam_role.aws_lbc.name
}

resource "aws_eks_pod_identity_association" "aws_lbc" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  service_account = "aws-load-balancer-controller"
  role_arn        = aws_iam_role.aws_lbc.arn
}

resource "helm_release" "aws_lbc" {
  depends_on = [helm_release.karpenter]

  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.16.0"

  values = [<<-EOT
    clusterName: ${var.cluster_name}
    serviceAccount:
      name: aws-load-balancer-controller
    vpcId: ${var.vpc_id}
  EOT
  ]
}
