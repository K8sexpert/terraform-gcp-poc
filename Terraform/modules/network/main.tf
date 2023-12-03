locals {
  # locals for google_compute_router_nat
  # nat_ip_allocate_option = length(var.nat_ips) > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"
  subnets = {
    for x in var.subnets :
    "${x.subnet_region}/${x.subnet_name}" => x
  }
}

resource "google_compute_network" "sap_poc_vpc" {
  name                                      = "${var.vpc_name}-vpc"
  routing_mode                              = var.routing_mode
  project                                   = var.project_id
  mtu                                       = var.mtu
  enable_ula_internal_ipv6                  = var.enable_ipv6_ula
  internal_ipv6_range                       = var.internal_ipv6_range
  auto_create_subnetworks                   = var.auto_create_subnetworks
}

resource "google_compute_router" "sop_poc_router" {
  name    = "${var.vpc_name}-router"
  region  = var.region 
  network = google_compute_network.sap_poc_vpc.id
}

resource "google_compute_address" "nat_reserved_ip" {
  project = var.project_id
  name = var.ip_name
  region = var.region
  
}
resource "google_compute_router_nat" "nat" {
  name                                = "${var.vpc_name}-nat"
  router                              = google_compute_router.sop_poc_router.name
  region                              = google_compute_router.sop_poc_router.region
  nat_ip_allocate_option              = "MANUAL_ONLY"
  nat_ips                             = [google_compute_address.nat_reserved_ip.self_link]
  source_subnetwork_ip_ranges_to_nat  = var.source_subnetwork_ip_ranges_to_nat
}

resource "google_compute_subnetwork" "subnetwork" {

  for_each                   = local.subnets
  name                       = each.value.subnet_name
  ip_cidr_range              = each.value.subnet_ip
  region                     = each.value.subnet_region
  private_ip_google_access   = lookup(each.value, "subnet_private_access", "false")
  private_ipv6_google_access = lookup(each.value, "subnet_private_ipv6_access", null)
  dynamic "log_config" {
    for_each = coalesce(lookup(each.value, "subnet_flow_logs", null), false) ? [{
      aggregation_interval = each.value.subnet_flow_logs_interval
      flow_sampling        = each.value.subnet_flow_logs_sampling
      metadata             = each.value.subnet_flow_logs_metadata
      filter_expr          = each.value.subnet_flow_logs_filter
      metadata_fields      = each.value.subnet_flow_logs_metadata_fields
    }] : []
    content {
      aggregation_interval = log_config.value.aggregation_interval
      flow_sampling        = log_config.value.flow_sampling
      metadata             = log_config.value.metadata
      filter_expr          = log_config.value.filter_expr
      metadata_fields      = log_config.value.metadata == "CUSTOM_METADATA" ? log_config.value.metadata_fields : null
    }
  }
  network     = google_compute_network.sap_poc_vpc.name
  project     = var.project_id
  description = lookup(each.value, "description", null)
  secondary_ip_range = [
    for i in range(
      length(
        contains(
        keys(var.secondary_ranges), each.value.subnet_name) == true
        ? var.secondary_ranges[each.value.subnet_name]
        : []
    )) :
    var.secondary_ranges[each.value.subnet_name][i]
  ]

  purpose          = lookup(each.value, "purpose", null)
  role             = lookup(each.value, "role", null)
  stack_type       = lookup(each.value, "stack_type", null)
  ipv6_access_type = lookup(each.value, "ipv6_access_type", null)

}