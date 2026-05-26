output "dev_public_ips" {
  description = "Public IP addresses for the Dev environment"
  value       = module.dev-infra.public_ips
}

output "stg_public_ips" {
  description = "Public IP addresses for the Staging environment"
  value       = module.stg-infra.public_ips
}

output "prod_public_ips" {
  description = "Public IP addresses for the Prod environment"
  value       = module.prod-infra.public_ips
}
