# External DNS Module

Módulo Terraform para configurar IAM Role e Pod Identity Association para o External DNS gerenciar registros DNS no Route53.

## Recursos Criados

- **IAM Role**: Role para o External DNS com trust policy para EKS Pod Identity
- **IAM Policy**: Permissões para gerenciar registros DNS no Route53
- **Pod Identity Association**: Vincula a IAM Role ao ServiceAccount do External DNS

## Uso

```hcl
module "external_dns" {
  source = "../../modules/external-dns"

  cluster_name = module.eks.cluster_name
  hosted_zone_arns = [
    "arn:aws:route53:::hostedzone/Z1234567890ABC"
  ]

  tags = var.common_tags
}
```

## Permissões IAM

O módulo cria as seguintes permissões:

- `route53:ChangeResourceRecordSets` - Nas hosted zones especificadas
- `route53:ListHostedZones` - Global
- `route53:ListResourceRecordSets` - Global
- `route53:ListTagsForResource` - Global

## Configuração no Helm Chart

Após aplicar este módulo, configure o Helm chart do External DNS com:

```yaml
serviceAccount:
  name: external-dns
  annotations: {}  # Pod Identity não requer anotações

podLabels:
  app: external-dns
```

## Inputs

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|-------------|
| cluster_name | Nome do cluster EKS | string | - | Sim |
| hosted_zone_arns | Lista de ARNs das Hosted Zones | list(string) | - | Sim |
| namespace | Namespace do External DNS | string | "external-dns" | Não |
| service_account | ServiceAccount do External DNS | string | "external-dns" | Não |
| tags | Tags para os recursos | map(string) | {} | Não |

## Outputs

| Nome | Descrição |
|------|-----------|
| iam_role_arn | ARN da IAM Role |
| iam_role_name | Nome da IAM Role |
