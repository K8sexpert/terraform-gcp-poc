locals {
  gke_subnet_pod_name = "k8s-pod-range"
  gke_subnet_svc_name = "k8s-service-range"
  gke_subnet_sec_pod  = "10.20.200.0/21"
  gke_subnet_sec_svc = "10.20.208.0/24"
  master_authorized_networks = [{
    cidr_block   = "10.21.0.0/24"
    display_name = "ip1"
    },
    {
      cidr_block   = "10.22.0.0/24"
      display_name = "ip2"
    }
  ]
}

module "network" {
  source       = "./modules/network"
  vpc_name     = "sap-poc"
  project_id   = "pub-sap-sbx-poc-406406"
  routing_mode = "REGIONAL"

  subnets = [
    {
      subnet_name   = "private-subnet-01"
      subnet_ip     = "10.20.8.0/24"
      subnet_region = "us-east4"
    }
  ]

 secondary_ranges = {

    "private-subnet-01" = [
      {
        range_name    = local.gke_subnet_pod_name
        ip_cidr_range = local.gke_subnet_sec_pod
      },
      {
        range_name    = local.gke_subnet_svc_name
        ip_cidr_range = local.gke_subnet_sec_svc
      }
    ]
  }
}

module "cluster" {
  source                     = "./modules/cluster"
  project_id                 = "pub-sap-sbx-poc-406406"
  name                       = "sap-poc-gke"
  region                     = "us-east4"
  zones                      = ["us-east4-a"]
  node_locations             = "us-east4-a"
  network                    = "sap-poc-vpc"
  subnetwork                 = "private-subnet-01"
  ip_range_pods              = local.gke_subnet_pod_name
  ip_range_services          = local.gke_subnet_svc_name
  enable_private_endpoint    = true
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.16.0.0/28"
  master_authorized_networks = local.master_authorized_networks
  service_account            = "sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
}
