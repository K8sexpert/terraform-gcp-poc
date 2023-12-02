locals {
  // ID of the cluster
  cluster_id = google_container_cluster.primary.id

  // location
  location = var.regional ? var.region : var.zones[0]
  network_project_id = var.network_project_id != "" ? var.network_project_id : var.project_id
  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]
  release_channel    = var.release_channel != null ? [{ channel : var.release_channel }] : []
  region                            = var.region
  zone                              = var.zones
  node_locations                    = var.node_locations
  node_pools                        = var.node_pools
  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]
  service_account                   = var.service_account
}
resource "google_container_cluster" "primary" {

  name            = var.name
  description     = var.description
  project         = var.project_id
  resource_labels = var.cluster_resource_labels

  location = local.location
  deletion_protection = false

  cluster_ipv4_cidr = var.cluster_ipv4_cidr
  network           = "projects/${local.network_project_id}/global/networks/${var.network}"
  subnetwork        = "projects/${local.network_project_id}/regions/${local.region}/subnetworks/${var.subnetwork}"
  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  dynamic "release_channel" {
    for_each = local.release_channel

    content {
      channel = release_channel.value.channel
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes    = var.enable_private_nodes,
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }] : []

    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
      dynamic "master_global_access_config" {
        for_each = var.master_global_access_enabled ? [var.master_global_access_enabled] : []
        content {
          enabled = master_global_access_config.value
        }
      }
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  # initial_node_count = 1
  node_pool {
    name               = "mc-node-pool"
    initial_node_count = var.initial_node_count

    node_config {
      image_type       = lookup(var.node_pools[0], "image_type", "COS_CONTAINERD")
      machine_type     = lookup(var.node_pools[0], "machine_type", "e2-small")
      min_cpu_platform = lookup(var.node_pools[0], "min_cpu_platform", "")
      dynamic "gcfs_config" {
        for_each = lookup(var.node_pools[0], "enable_gcfs", false) ? [true] : []
        content {
          enabled = gcfs_config.value
        }
      }

      dynamic "gvnic" {
        for_each = lookup(var.node_pools[0], "enable_gvnic", false) ? [true] : []
        content {
          enabled = gvnic.value
        }
      }

      service_account = lookup(var.node_pools[0], "service_account", local.service_account)
    }

  }

}