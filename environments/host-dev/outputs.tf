output "vpc_name" {
  value = module.vpc.network_name
}

output "vpc_self_link" {
  value = module.vpc.network_self_link
}

output "subnet_self_links" {
  description = "Share these with service project environments"
  value       = module.subnets.subnet_self_links
}

output "subnet_cidrs" {
  value = module.subnets.subnet_cidrs
}

output "shared_vpc_service_projects" {
  value = module.shared_vpc.service_projects
}
