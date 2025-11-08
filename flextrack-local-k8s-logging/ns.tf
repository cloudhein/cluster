# Create namespace if it doesn't exist
resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.logging_namespace
  }
}