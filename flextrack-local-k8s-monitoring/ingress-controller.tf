resource "helm_release" "nginx_ingress" {
  name       = var.ingress_release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.monitoring_namespace

  set = [
    {
      name  = "controller.ingressClassResource.name"
      value = var.ingressclassresource
    },
    {
      name  = "controller.ingressClass"
      value = var.ingressclassresource
    },
    {
      name  = "controller.service.enabled"
      value = "true"
    }
  ]

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}