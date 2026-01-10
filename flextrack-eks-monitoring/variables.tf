####### profile to authenticate to aws #######

variable "aws_auth_profile" {
  type        = string
  description = "AWS profile to use for authentication"
  default     = "admin-cli"
}

variable "aws_auth_region" {
  type        = string
  description = "AWS region to use for authentication"
  default     = "ap-southeast-1"
}

####### monitoring stack variables #######

variable "slack_webhook_url" {
  description = "Slack webhook URL for alerting"
  type        = string
  sensitive   = true
}

variable "monitoring_namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "monitoring_release_name" {
  description = "monitoring release name"
  type        = string
  default     = "monitoring"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "dev-eks-cluster"
}