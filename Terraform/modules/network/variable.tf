variable "vpc_name" {
  description = "name of the vpc created in network module"
}

variable "project_id" {
  description = "The ID of the project where this VPC will be created"
  type        = string
}

variable "region" {
  description = "The ID of the project where this VPC will be created"
  type        = string
  default = "us-east4"
}

variable "enable_ipv6_ula" {
  type        = bool
  description = "Enabled IPv6 ULA, this is a permenant change and cannot be undone! (default 'false')"
  default     = false
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "mtu" {
  type        = number
  description = "The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively."
  default     = 0
}

variable "internal_ipv6_range" {
  type        = string
  default     = null
  description = "When enabling IPv6 ULA, optionally, specify a /48 from fd20::/20 (default null)"
}

variable "ip_name" {
  type        = string
  default     = "ip-nat"
  description = "reserved IP address name"
}

# variable "nat_ips" {
#   type        = list(string)
#   description = "List of self_links of external IPs. Changing this forces a new NAT to be created. Value of `nat_ip_allocate_option` is inferred based on nat_ips. If present set to MANUAL_ONLY, otherwise AUTO_ONLY."
#   default     = []
# }

variable "source_subnetwork_ip_ranges_to_nat" {
  type        = string
  description = "Defaults to ALL_SUBNETWORKS_ALL_IP_RANGES. How NAT should be configured per Subnetwork. Valid values include: ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, LIST_OF_SUBNETWORKS. Changing this forces a new NAT to be created."
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "router_name" {
  description = "name of the vpc created in network module"
  default     = "mc-dev-router"
}

variable "nat_name" {
  description = "name of the vpc created in network module"
  default     = "mc-dev-nat"
}

variable "subnets" {
  type = list(object({
    subnet_name                      = string
    subnet_ip                        = string
    subnet_region                    = string
    subnet_private_access            = optional(string, "true")
    subnet_private_ipv6_access       = optional(string)
    subnet_flow_logs                 = optional(string, "true")
    subnet_flow_logs_interval        = optional(string, "INTERVAL_5_SEC")
    subnet_flow_logs_sampling        = optional(string, "0.5")
    subnet_flow_logs_metadata        = optional(string, "INCLUDE_ALL_METADATA")
    subnet_flow_logs_filter          = optional(string, "true")
    subnet_flow_logs_metadata_fields = optional(list(string), [])
    description                      = optional(string)
    purpose                          = optional(string)
    role                             = optional(string)
    stack_type                       = optional(string)
    ipv6_access_type                 = optional(string)
  }))
  description = "The list of subnets being created"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

# variable "num_of_subnets" {
#   type = number
#   description = "num of subnets to be created"
# }

# variable "firewall_name" {
#   description = "name of the vpc created in network module"
# }




# variable "rules" {
#   description = "This is DEPRICATED and available for backward compatiblity. Use ingress_rules and egress_rules variables. List of custom rule definitions"
#   default     = []
#   type = list(object({
#     name                    = string
#     description             = optional(string, null)
#     direction               = optional(string, "INGRESS")
#     priority                = optional(number, null)
#     ranges                  = optional(list(string), [])
#     source_tags             = optional(list(string))
#     source_service_accounts = optional(list(string))
#     target_tags             = optional(list(string))
#     target_service_accounts = optional(list(string))

#     allow = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     deny = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     log_config = optional(object({
#       metadata = string
#     }))
#   }))
# }

# variable "ingress_rules" {
#   description = "List of ingress rules. This will be ignored if variable 'rules' is non-empty"
#   default     = []
#   type = list(object({
#     name                    = string
#     description             = optional(string, null)
#     priority                = optional(number, null)
#     destination_ranges      = optional(list(string), [])
#     source_ranges           = optional(list(string), [])
#     source_tags             = optional(list(string))
#     source_service_accounts = optional(list(string))
#     target_tags             = optional(list(string))
#     target_service_accounts = optional(list(string))

#     allow = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     deny = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     log_config = optional(object({
#       metadata = string
#     }))
#   }))
# }

# variable "egress_rules" {
#   description = "List of egress rules. This will be ignored if variable 'rules' is non-empty"
#   default     = []
#   type = list(object({
#     name                    = string
#     description             = optional(string, null)
#     priority                = optional(number, null)
#     destination_ranges      = optional(list(string), [])
#     source_ranges           = optional(list(string), [])
#     source_tags             = optional(list(string))
#     source_service_accounts = optional(list(string))
#     target_tags             = optional(list(string))
#     target_service_accounts = optional(list(string))

#     allow = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     deny = optional(list(object({
#       protocol = string
#       ports    = optional(list(string))
#     })), [])
#     log_config = optional(object({
#       metadata = string
#     }))
#   }))
# }

# variable "num_of_private_sub" {
#   type = number
#   description = "num of subnets to be created"
# }

# variable "num_of_public_sub" {
#   type = number
#   description = "num of subnets to be created"
# }

# variable "aggregation_interval" {
#   type = bool
#   description = "aggregation interval for collecting flow logs"
#   default = "INTERVAL_5_SEC"
# }

# variable "secondary_ranges" {
#   type        = map(list(object({ range_name = string, ip_cidr_range = string })))
#   description = "Secondary ranges that will be used in some of the subnets"
#   default     = {}
# }
