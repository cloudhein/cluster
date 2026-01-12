# 2. Create IAM Policy for Loki S3 Access
resource "aws_iam_policy" "loki_s3" {
  name        = "LokiS3AccessPolicy-${var.cluster_name}"
  description = "Policy for Loki to access S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
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

# 3. Create IAM Role for Service Account (IRSA)
resource "aws_iam_role" "loki_irsa" {
  name               = "LokiIRSA-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.loki_s3_assume_role_policy.json
}

##### trust relationship policy for loki s3 storage
data "aws_iam_policy_document" "loki_s3_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      # ✅ Use the local variable for the OIDC provider ARN
      identifiers = [local.oidc_provider_arn]
    }

    condition {
      test = "StringEquals"
      # ✅ Use the local variable for the OIDC issuer url
      variable = "${replace(local.eks_oidc_issuer_url, "https://", "")}:sub"
      # ✅ CRITICAL: This must match "system:serviceaccount:<namespace>:<sa-name>"
      values = ["system:serviceaccount:monitoring:loki"]
    }
  }
}

# 4. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "loki_s3_attach" {
  role       = aws_iam_role.loki_irsa.name
  policy_arn = aws_iam_policy.loki_s3.arn
}