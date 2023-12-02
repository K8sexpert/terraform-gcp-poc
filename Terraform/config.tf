provider "google" {
  credentials = file("")
  project     = "pub-sap-sbx-poc-406406"
  region      = "us-east4"

  default_labels = {
    environment = "poc"
  }
}

terraform {
  backend "gcs" {
    bucket  = "terraform-state-file-bucket-poc"
    prefix  = "infra/poc"
  }
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 5.4.0"
    }
  }
}