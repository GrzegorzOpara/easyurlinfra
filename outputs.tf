# output "static_storage_account_name" {
#   description = "Storage Account name for static content"
#   value       = module.prod.static_storage_account_name
# }

# output "static_storage_account_primary_access_key" {
#   value = module.prod.static_storage_account_primary_access_key
#   sensitive = true
# }

output "be_web_app_url" {
  value = module.prod.be_web_app_url
}

output "fe_web_app_url" {
    value = module.prod.fe_web_app_url
}

# output "fe_web_app_api_key" {
#     value = module.prod.fe_web_app_api_key
# }