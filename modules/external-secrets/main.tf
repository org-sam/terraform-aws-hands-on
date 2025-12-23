data "aws_iam_policy_document" "pod_identity_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eso" {
  name               = "${var.env}-${var.name}-external-secrets-role"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_trust.json

  tags = var.tags
}

data "aws_iam_policy_document" "eso_policy" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = var.secrets_arns
  }
}

resource "aws_iam_policy" "eso" {
  name   = "${var.env}-${var.name}-external-secrets-policy"
  policy = data.aws_iam_policy_document.eso_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso.name
  policy_arn = aws_iam_policy.eso.arn
}

resource "aws_eks_pod_identity_association" "eso" {
  cluster_name    = var.cluster_name
  namespace       = "external-secrets"
  service_account = "external-secrets"
  role_arn        = aws_iam_role.eso.arn

  depends_on = [
    aws_iam_role_policy_attachment.eso_attach
  ]
}
