output "vpc-name" {
  description = "name of the vpc"
  value = var.vpc_name
}

output "project" {
    description = "project id"
    value = var.project_id
}

output "router-name" {
    description = "name of the router"
    value = var.router_name
}

output "nat-name" {
    description = "name of the nat"
    value = var.nat_name
}