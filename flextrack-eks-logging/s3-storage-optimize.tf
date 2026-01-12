# ---------------------------------------------------------
# 5. S3 Lifecycle Policy (Cost Optimization)
# ---------------------------------------------------------
# Automatically delete logs older than 30 days
resource "aws_s3_bucket_lifecycle_configuration" "loki_lifecycle" {
  bucket = aws_s3_bucket.loki_storage.id

  rule {
    id     = "DeleteOldLogs"
    status = "Enabled"

    # Apply to all objects in the bucket
    filter {
      prefix = ""
    }

    expiration {
      days = var.loki_retention_days
    }

    # Optional: If you wanted to move to Glacier first, you would use this block:
    # transition {
    #   days          = 30
    #   storage_class = "GLACIER"
    # }
    # expiration {
    #   days = 365
    # }
  }
}

# ---------------------------------------------------------
# 6. S3 Bucket Policy (Security Best Practice)
# ---------------------------------------------------------
# Strictly allow only the Loki IAM Role to access this bucket
resource "aws_s3_bucket_policy" "loki_bucket_policy" {
  bucket = aws_s3_bucket.loki_storage.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLokiServiceAccount"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.loki_irsa.arn
        }
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.loki_storage.arn,
          "${aws_s3_bucket.loki_storage.arn}/*"
        ]
      }
    ]
  })
}