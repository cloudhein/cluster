resource "helm_release" "reloader" {
  name = "reloader"

  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"

  namespace = var.reloader_namespace

  create_namespace = var.reloader_create_ns
}