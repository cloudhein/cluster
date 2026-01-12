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

####### cluster variables #######
variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "dev-eks-cluster"
}

####### logging stack variables #######
variable "s3_bucket_name" {
  description = "Base name for the S3 bucket"
  type        = string
  default     = "flextrack-loki-logs"
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "logging-ns" {
  description = "Logging Namespace"
  type        = string
  default     = "monitoring"
}

variable "loki_retention_days" {
  description = "Number of days to keep Loki logs in S3 before deleting"
  type        = number
  default     = 30
}

variable "helm_timeout" {
  type        = number
  description = "Timeout for Helm releases in seconds"
  default     = 900
}
