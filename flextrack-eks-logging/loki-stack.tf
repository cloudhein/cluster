# ---------------------------------------------------------
# 1. Install Loki (Single Binary using S3) - FIXED RESOURCES
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
        storage = {
          type = "s3"
          bucketNames = {
            chunks = aws_s3_bucket.loki_storage.id
            ruler  = aws_s3_bucket.loki_storage.id
            admin  = aws_s3_bucket.loki_storage.id
          }
          s3 = {
            region   = var.region
            insecure = false
          }
        }
      }

      serviceAccount = {
        create = true
        name   = "loki"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.loki_irsa.arn
        }
      }

      # ✅ FIXED: Added Resources for the Main Loki Pod
      # Usage was ~114Mi. Setting Request to 256Mi.
      singleBinary = {
        replicas = 1
        persistence = {
          enabled = true
          size    = "10Gi"
        }
        resources = {
          requests = {
            memory = "256Mi"
            cpu    = "100m"
          }
          limits = {
            memory = "512Mi"
            cpu    = "500m"
          }
        }
      }

      # ✅ FIXED: Added Resources for the Gateway (Nginx)
      # Usage was ~11Mi. Setting Request to 32Mi.
      gateway = {
        resources = {
          requests = {
            memory = "32Mi"
            cpu    = "50m"
          }
          limits = {
            memory = "64Mi"
            cpu    = "100m"
          }
        }
      }

      # Disable unneeded components
      write   = { replicas = 0 }
      read    = { replicas = 0 }
      backend = { replicas = 0 }
      minio   = { enabled = false }

      chunksCache  = { enabled = false }
      resultsCache = { enabled = false }

      test = { enabled = false }
      monitoring = {
        selfMonitoring = { enabled = false }
      }

      # ✅ FIXED: Added Resources for Canary
      # Usage was ~13Mi. Setting Request to 32Mi.
      lokiCanary = {
        enabled = true
        resources = {
          requests = {
            memory = "32Mi"
            cpu    = "20m"
          }
          limits = {
            memory = "64Mi"
            cpu    = "50m"
          }
        }
        # ✅ FIX: Clear Affinity/NodeSelector to allow scheduling on any node (System or Old App)
        nodeSelector = {}
        affinity     = {}
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