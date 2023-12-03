# Create a firewall rule to allow egress traffic from the private subnet
resource "google_compute_firewall" "private_subnet_firewall" {
  name      = "private-subnet-egress"
  network   = module.network.vpc-name
  project      = "pub-sap-sbx-poc-406406"

    allow {
    protocol  = "tcp"
    ports     = ["80"]
  }

  source_ranges   = ["10.20.8.0/24"]
  target_tags     = ["sap-poc-node-pool"]
}

resource "google_compute_firewall" "iap_vm_firewall" {
  name            = "allow-ingress-from-iap"
  network         = module.network.vpc-name
  project      = "pub-sap-sbx-poc-406406"
  enable_logging  = "true"
  direction       = "INGRESS"

allow {
    protocol    = "tcp"
    ports       = ["22", "3389"]
  }

  source_ranges     = ["35.235.240.0/20"]
  # target_tags       = ["sap-poc-instance"]
}