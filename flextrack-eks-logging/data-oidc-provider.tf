# ---------------------------------------------------------
# 0. Data Sources (The Bridge to your EKS Repo)
# ---------------------------------------------------------

# Look up the existing EKS cluster by name
data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

# Get current account ID (needed to construct the ARN manually)
data "aws_caller_identity" "current" {}

# Helper to construct the OIDC ARN dynamically
locals {
  # Get the Issuer URL from the cluster data source
  eks_oidc_issuer_url = data.aws_eks_cluster.target.identity[0].oidc[0].issuer

  # Construct the ARN: arn:aws:iam::<ACCOUNT_ID>:oidc-provider/<ISSUER_URL_WITHOUT_HTTPS>
  oidc_provider_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(local.eks_oidc_issuer_url, "https://", "")}"
}
