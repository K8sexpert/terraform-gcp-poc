# pub-sap-poc-project

This repo contains to Google cloud plaform resources to host an application
google kubernetes cluster.

GCP Infra resources created using terraform hashicorp language.

1) Service Accounts
2) Google Cloud Storage
3) VPC Network
4) Google Compute Engine
5) Google Container Registry
6) Endpoints
7) Google Kubernetes Engine

This Modules can be used to create single VPC Network, clous storage Buckets
and GKE cluster in the GCP Project. 

## Software Requirements

- Terraform version       >= 5.4.0

## usage

Examples of how to use this modules are located in the Cluster.tf, storage.tf

Simple usage is as follows:

```hcl

Example :-

module "storage" {
  source        = "./modules/storage"
  project_id    = "pub-sap-sbx-poc-406406"
  name          = "terraform-state-file-bucket-poc"
  location      = "us-east4"
  storage_class = "STANDARD"
  force_destroy = false
  versioning = true
}

Example :-

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

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_create\_subnetworks | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources. | `bool` | `false` | no |
| delete\_default\_internet\_gateway\_routes | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| description | An optional description of this resource. The resource must be recreated to modify this field. | `string` | `""` | no |
| egress\_rules | List of egress rules. This will be ignored if variable 'rules' is non-empty | <pre>list(object({<br>    name                    = string<br>    description             = optional(string, null)<br>    priority                = optional(number, null)<br>    destination_ranges      = optional(list(string), [])<br>    source_ranges           = optional(list(string), [])<br>    source_tags             = optional(list(string))<br>    source_service_accounts = optional(list(string))<br>    target_tags             = optional(list(string))<br>    target_service_accounts = optional(list(string))<br><br>    allow = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    deny = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    log_config = optional(object({<br>      metadata = string<br>    }))<br>  }))</pre> | `[]` | no |
| enable\_ipv6\_ula | Enabled IPv6 ULA, this is a permenant change and cannot be undone! (default 'false') | `bool` | `false` | no |
| firewall\_rules | This is DEPRICATED and available for backward compatiblity. Use ingress\_rules and egress\_rules variables. List of firewall rules | <pre>list(object({<br>    name                    = string<br>    description             = optional(string, null)<br>    direction               = optional(string, "INGRESS")<br>    priority                = optional(number, null)<br>    ranges                  = optional(list(string), [])<br>    source_tags             = optional(list(string))<br>    source_service_accounts = optional(list(string))<br>    target_tags             = optional(list(string))<br>    target_service_accounts = optional(list(string))<br><br>    allow = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    deny = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    log_config = optional(object({<br>      metadata = string<br>    }))<br>  }))</pre> | `[]` | no |
| ingress\_rules | List of ingress rules. This will be ignored if variable 'rules' is non-empty | <pre>list(object({<br>    name                    = string<br>    description             = optional(string, null)<br>    priority                = optional(number, null)<br>    destination_ranges      = optional(list(string), [])<br>    source_ranges           = optional(list(string), [])<br>    source_tags             = optional(list(string))<br>    source_service_accounts = optional(list(string))<br>    target_tags             = optional(list(string))<br>    target_service_accounts = optional(list(string))<br><br>    allow = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    deny = optional(list(object({<br>      protocol = string<br>      ports    = optional(list(string))<br>    })), [])<br>    log_config = optional(object({<br>      metadata = string<br>    }))<br>  }))</pre> | `[]` | no |
| internal\_ipv6\_range | When enabling IPv6 ULA, optionally, specify a /48 from fd20::/20 (default null) | `string` | `null` | no |
| mtu | The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively. | `number` | `0` | no |
| network\_firewall\_policy\_enforcement\_order | Set the order that Firewall Rules and Firewall Policies are evaluated. Valid values are `BEFORE_CLASSIC_FIREWALL` and `AFTER_CLASSIC_FIREWALL`. (default null or equivalent to `AFTER_CLASSIC_FIREWALL`) | `string` | `null` | no |
| network\_name | The name of the network being created | `string` | n/a | yes |
| project\_id | The ID of the project where this VPC will be created | `string` | n/a | yes |
| routes | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| routing\_mode | The network routing mode (default 'GLOBAL') | `string` | `"GLOBAL"` | no |
| secondary\_ranges | Secondary ranges that will be used in some of the subnets | `map(list(object({ range_name = string, ip_cidr_range = string })))` | `{}` | no |
| shared\_vpc\_host | Makes this project a Shared VPC host if 'true' (default 'false') | `bool` | `false` | no |
| subnets | The list of subnets being created | <pre>list(object({<br>    subnet_name                      = string<br>    subnet_ip                        = string<br>    subnet_region                    = string<br>    subnet_private_access            = optional(string)<br>    subnet_private_ipv6_access       = optional(string)<br>    subnet_flow_logs                 = optional(string)<br>    subnet_flow_logs_interval        = optional(string)<br>    subnet_flow_logs_sampling        = optional(string)<br>    subnet_flow_logs_metadata        = optional(string)<br>    subnet_flow_logs_filter          = optional(string)<br>    subnet_flow_logs_metadata_fields = optional(list(string))<br>    description                      = optional(string)<br>    purpose                          = optional(string)<br>    role                             = optional(string)<br>    stack_type                       = optional(string)<br>    ipv6_access_type                 = optional(string)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| network | The created network |
| network\_id | The ID of the VPC being created |
| network\_name | The name of the VPC being created |
| network\_self\_link | The URI of the VPC being created |
| project\_id | VPC project id |
| route\_names | The route names associated with this VPC |
| subnets | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets. |
| subnets\_flow\_logs | Whether the subnets will have VPC flow logs enabled |
| subnets\_ids | The IDs of the subnets being created |
| subnets\_ips | The IPs and CIDRs of the subnets being created |
| subnets\_names | The names of the subnets being created |
| subnets\_private\_access | Whether the subnets will have access to Google API's without a public IP |
| subnets\_regions | The region where the subnets will be created |
| subnets\_secondary\_ranges | The secondary ranges associated with these subnets |
| subnets\_self\_links | The self-links of subnets being created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->