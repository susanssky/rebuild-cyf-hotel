# call s3 module
module "frontend" {
  source = "./s3_module"
}

output "frontend-url" {
  value = module.frontend.url
}
# ======================= moved to s3_module =====================
# resource "aws_s3_bucket" "frontend" {
#   bucket = "cyf-cloud-week4"
#   tags = {
#     Name = "${var.env_prefix}-s3"
#   }
# }
# resource "aws_s3_bucket_ownership_controls" "frontend-control" {
#   bucket = aws_s3_bucket.frontend.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }
# resource "aws_s3_bucket_public_access_block" "frontend-pab" {
#   bucket = aws_s3_bucket.frontend.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "frontend-acl" {
#   depends_on = [aws_s3_bucket_ownership_controls.frontend-control, aws_s3_bucket_public_access_block.frontend-pab]

#   bucket = aws_s3_bucket.frontend.id
#   acl    = "public-read"
# }

# resource "aws_s3_bucket_policy" "policy" {
#   depends_on = [aws_s3_bucket_ownership_controls.frontend-control, aws_s3_bucket_public_access_block.frontend-pab]
#   bucket     = aws_s3_bucket.frontend.id

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : "*",
#         "Action" : "s3:*",
#         "Resource" : "arn:aws:s3:::${aws_s3_bucket.frontend.bucket}/*"
#       }
#     ]
#   })
# }
# module "template_files" {
#   source = "hashicorp/dir/template"
#   base_dir = "${path.module}/dist"
# }
# resource "aws_s3_object" "frontend-object" {
#   bucket       = aws_s3_bucket.frontend.id
#   for_each     = module.template_files.files
#   key          = each.key
#   content_type = each.value.content_type
#   source       = each.value.source_path
#   content      = each.value.content
# }
# resource "aws_s3_bucket_website_configuration" "frontend-website" {
#   depends_on = [aws_s3_bucket_acl.frontend-acl]
#   bucket     = aws_s3_bucket.frontend.id

#   index_document {
#     suffix = "index.html"
#   }

# }
