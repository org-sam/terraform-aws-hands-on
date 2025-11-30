# Terraform EKS com Karpenter e AWS Load Balancer Controller

Projeto Terraform para provisionamento de cluster EKS na AWS com autoscaling via Karpenter e AWS Load Balancer Controller.

## Arquitetura

- **VPC**: Rede isolada com subnets públicas e privadas em 2 zonas de disponibilidade
- **EKS**: Cluster Kubernetes v1.34 com node group inicial
- **Karpenter**: Autoscaling inteligente de nodes baseado em demanda
- **AWS Load Balancer Controller**: Gerenciamento automático de ALB/NLB

## Estrutura do Projeto

```
.
├── 0-locals.tf                  # Variáveis locais e configurações
├── 1-providers.tf               # Configuração de providers (AWS, Helm, Kubectl)
├── 2-vpc.tf                     # VPC com subnets públicas e privadas
├── 3-eks.tf                     # Cluster EKS e node groups
├── 4-karpenter.tf               # Instalação do Karpenter
├── 5-karpenter_nodepools.tf     # NodePools e EC2NodeClass do Karpenter
├── 6-aws-lbc.tf                 # AWS Load Balancer Controller
└── deploy-k8s-demo/             # Exemplos de deployments
```

## Pré-requisitos

- Terraform >= 1.14
- AWS CLI v2 configurado
- kubectl instalado
- helm instalado

## Configuração

### Variáveis Principais (0-locals.tf)

- **Ambiente**: staging
- **Região**: us-east-2
- **Zonas**: us-east-2a, us-east-2b
- **EKS Version**: 1.34
- **VPC CIDR**: 10.200.0.0/16

### Karpenter NodePool

- **Tipos de instância**: t3, t3a (2-16 vCPUs)
- **Capacity Type**: Spot
- **Limites**: 100 CPUs, 256Gi memória
- **Volume**: 30Gi gp3

## Deploy

1. Inicializar Terraform:
```bash
terraform init
```

2. Revisar plano:
```bash
terraform plan
```

3. Aplicar configuração:
```bash
terraform apply
```

4. Configurar kubectl:
```bash
aws eks update-kubeconfig --region us-east-2 --name staging-demo
```

## Componentes

### VPC
- 2 subnets públicas (10.200.64.0/19, 10.200.96.0/19)
- 2 subnets privadas (10.200.0.0/19, 10.200.32.0/19)
- Single NAT Gateway (otimização de custo)
- Tags para integração com EKS e Karpenter

### EKS
- Node group inicial: 1-3 nodes t3.medium/t3a.medium (Spot)
- Addons: kube-proxy, vpc-cni, coredns, eks-pod-identity-agent, metrics-server
- Secrets encryption habilitado
- Public endpoint habilitado

### Karpenter
- Autoscaling baseado em demanda real
- Consolidação de nodes após 30s de ociosidade
- Suporte a instâncias Spot
- AMI: Amazon Linux 2023

### AWS Load Balancer Controller
- Criação automática de ALB/NLB
- Integração com Ingress do Kubernetes
- Pod Identity para autenticação




## Resolução de Problemas

### Erro 403 ao localizar chart do Karpenter

Se encontrar erro ao executar `terraform apply`:

```
Error: Unable to locate chart oci://public.ecr.aws/karpenter/karpenter
403 Forbidden
```

**Solução**:
```bash
helm registry logout public.ecr.aws
```
