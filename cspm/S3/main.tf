provider "aws" {
  region = "eu-east-1"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "sportradar-training-sensitive-data"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.public_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.public_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_bucket.arn}/*"
      }
    ]
  })
}

output "bucket_name" {
  value = aws_s3_bucket.public_bucket.bucket
}

output "bucket_url" {
  value = "http://${aws_s3_bucket.public_bucket.bucket}.s3.amazonaws.com"
}
