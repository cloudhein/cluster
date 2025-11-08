# Variables
variable "logging_namespace" {
  description = "Namespace for EFK stack"
  type        = string
  default     = "logging"
}

variable "elasticsearch_replicas" {
  description = "Number of Elasticsearch replicas"
  type        = number
  default     = 3
}

variable "elasticsearch_storage_size" {
  description = "Storage size for Elasticsearch PVC"
  type        = string
  default     = "20Gi"
}

variable "kibana_service_type" {
  description = "Kibana service type (LoadBalancer, ClusterIP, NodePort)"
  type        = string
  default     = "LoadBalancer"
}

variable "helm_timeout" {
  description = "Helm timeout seconds"
  type        = number
  default     = 900
}

variable "slack_webhook_url" {
  description = "Slack webhook URL for ElastAlert2 notifications"
  type        = string
  sensitive   = true
}