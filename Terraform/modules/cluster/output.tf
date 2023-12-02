output "ip_range_pods" {
  description = "The secondary IP range used for pods"
  value       = var.ip_range_pods
}

output "ip_range_services" {
  description = "The secondary IP range used for services"
  value       = var.ip_range_services
}

output "cluster_name" {
    description = "name of th cluster"
    value = var.name
}

output "cluster_ipv4_cidr" {
    description = "range of the cluster ipv4 cidr"
    value = var.cluster_ipv4_cidr
}

output "node_count" {
    description = "number of nodes in a cluster"
    value = var.initial_node_count
}

output "master_ipv4_cidr_block" {
    description = "The master_ipv4_cidr_block range"
    value = var.master_ipv4_cidr_block
}