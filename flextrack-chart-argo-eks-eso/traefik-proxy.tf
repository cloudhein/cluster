# --------------------------------------------------------
# Install Traefik Ingress Controller via Terraform Helm Provider
# --------------------------------------------------------
resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://traefik.github.io/charts"
  chart      = "traefik"

  namespace        = var.traefik_namespace
  create_namespace = true

  # Load the values from your local YAML file
  # Adjust the path "${path.module}/..." if your file is in a different folder
  values = [
    file("${path.module}/config/traefik-values.yaml")
  ]

}