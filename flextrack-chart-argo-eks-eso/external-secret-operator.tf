resource "helm_release" "external_secrets" {
  name = "external-secrets"

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"

  namespace = var.eso_namespace

  create_namespace = true
}