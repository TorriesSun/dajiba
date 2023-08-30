resource "aws_s3_bucket" "root_s3" {
  bucket = var.root_domain
  
  policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "AllowCloudFrontServicePrincipal",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudfront.amazonaws.com"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.root_domain}/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${var.root_cdn.arn}"
                }
            }
        },
        {
            "Sid": "Stmt1546414471931",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::062550047379:role/github-actions-OIDC"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::${var.root_domain}"
        }
    ]
}
  EOF
}

resource "aws_s3_bucket_ownership_controls" "disable_root_s3_acl" {
  bucket = aws_s3_bucket.root_s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_website_configuration" "root_static_web" {
  bucket = aws_s3_bucket.root_s3.id

  index_document {
    suffix = "index.html"
  }
}