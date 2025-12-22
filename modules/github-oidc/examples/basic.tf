# Exemplo básico - Teste com AdministratorAccess
module "github_oidc" {
  source = "../../modules/github-oidc"

  env  = "dev"
  name = "demo"

  github_repositories = {
    infra-repo = {
      subjects = [
        "repo:myorg/infra-repo:ref:refs/heads/main",
        "repo:myorg/infra-repo:ref:refs/heads/develop"
      ]
      managed_policy_arns = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}

output "role_arn" {
  value = module.github_oidc.role_arns["infra-repo"]
}
