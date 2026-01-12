# ---------------------------------------------------------
# 1. Install Loki (Single Binary using S3)
# ---------------------------------------------------------
resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  version          = "6.6.6"
  namespace        = var.logging-ns
  create_namespace = true

  timeout = var.helm_timeout
  wait    = true

  # We use yamlencode to inject Terraform variables into the Helm values
  values = [
    yamlencode({
      deploymentMode = "SingleBinary"

      loki = {
        auth_enabled = false

        commonConfig = {
          replication_factor = 1
        }

        schemaConfig = {
          configs = [{
            from         = "2024-04-01"
            store        = "tsdb"
            object_store = "s3"
            schema       = "v13"
            index = {
              prefix = "index_"
              period = "24h"
            }
          }]
        }

        # ✅ DYNAMIC S3 CONFIGURATION
        storage = {
          type = "s3"
          bucketNames = {
            # Terraform injects the generated bucket ID here automatically
            chunks = aws_s3_bucket.loki_storage.id
            ruler  = aws_s3_bucket.loki_storage.id
            admin  = aws_s3_bucket.loki_storage.id
          }
          s3 = {
            region = var.region
            # We explicitly allow IRSA (no static keys needed)
            insecure = false
          }
        }
      }

      # ✅ SERVICE ACCOUNT CONFIGURATION
      serviceAccount = {
        create = true
        name   = "loki" # Must match the IAM Trust Policy
        annotations = {
          # Terraform injects the created IAM Role ARN here
          "eks.amazonaws.com/role-arn" = aws_iam_role.loki_irsa.arn
        }
      }

      # Optimizations for Single Binary
      singleBinary = {
        replicas = 1
        persistence = {
          enabled = true
          size    = "10Gi"
        }
      }

      # Disable components not needed for SingleBinary
      write   = { replicas = 0 }
      read    = { replicas = 0 }
      backend = { replicas = 0 }
      minio   = { enabled = false } # We use AWS S3, not Minio

      # ✅ CRITICAL FIX: Disable heavy caches that request 10GB RAM
      chunksCache  = { enabled = false }
      resultsCache = { enabled = false }

      # Disable self-monitoring to save resources
      test = { enabled = false }
      monitoring = {
        selfMonitoring = { enabled = false }
      }

      # Add this tolerations config to run this daemonset on karpenter system node group 
      # ✅ CORRECT LOCATION: Root level (not inside 'monitoring') 
      lokiCanary = {
        enabled = true
        tolerations = [
          {
            key      = "CriticalAddonsOnly"
            operator = "Exists"
            effect   = "NoSchedule"
          }
        ]
      }
    })
  ]

  depends_on = [
    aws_iam_role_policy_attachment.loki_s3_attach
  ]
}
