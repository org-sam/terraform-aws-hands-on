# Módulo ArgoCD

Instala o ArgoCD via Helm no cluster EKS.

## Recursos Criados

- Namespace `argocd`
- Helm Release do ArgoCD
- LoadBalancer para acesso externo

## Uso

```hcl
module "argocd" {
  source = "../../modules/argocd"

  env  = "dev"
  name = "myproject"
  
  tags = {
    Environment = "dev"
  }
}
```
