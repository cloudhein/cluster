# ---------------------------------------------------------
# 2. Install Promtail (Log Shipper)
# ---------------------------------------------------------
resource "helm_release" "promtail" {
  name       = "promtail"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "promtail"
  version    = "6.17.1"
  namespace  = var.logging-ns

  values = [
    yamlencode({
      config = {
        clients = [{
          # Points to the Loki Gateway created by the chart above
          url = "http://loki-gateway.monitoring.svc.cluster.local/loki/api/v1/push"
        }]
      }

      # ✅ ADDED: Allow Promtail to run on tainted System Nodes
      tolerations = [
        {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
          effect   = "NoSchedule"
        }
      ]
    })
  ]

  depends_on = [
    helm_release.loki
  ]
}