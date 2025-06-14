# call s3 module
module "frontend" {
  source = "./s3_module"
}

output "frontend-url" {
  value = module.frontend.url
}
