#1. Create S3 Bucket for Loki Storage
resource "random_id" "loki_storage_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "loki_storage" {
  bucket = "${var.s3_bucket_name}-${random_id.loki_storage_suffix.dec}"

  # For dev/test only - allows deleting bucket even if it has logs
  force_destroy = true # setting boolean value to true is dangerous in production environment for it will delete your remote backend s3 immediately without asking your permission

  tags = {
    Name        = "loki-storage"
    Environment = "Dev"
  }
}

# 2. Enable ACL for S3 Bucket
resource "aws_s3_bucket_ownership_controls" "s3_backend_ownership_controls" {
  bucket = aws_s3_bucket.loki_storage.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "aws-master-s3-bucket-acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_backend_ownership_controls]

  bucket = aws_s3_bucket.loki_storage.id
  acl    = "private"
}

# 3. Block Public Access for s3 bucket
resource "aws_s3_bucket_public_access_block" "loki-storage-acess-control" {
  bucket = aws_s3_bucket.loki_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
