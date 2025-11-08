locals {
  custom_prometheus_values = [
    "custom-kube-prometheus-stack.yml"
  ]
}

locals {
  service_monitor_files = [
    "throttler-service-monitor.yaml",
    "notifier-service-monitor.yaml"
  ]
}

locals {
  alerting_configs = {
    # PrometheusRule for alert definitions
    alerts = "alerts.yaml"
    # AlertmanagerConfig for routes and receivers
    routes_receivers = "routes_receivers.yaml"
  }
}

locals {
  ingress_rule_files = [
    "ingress.yaml"
  ]
}