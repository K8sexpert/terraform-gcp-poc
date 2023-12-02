module "storage" {
  source        = "./modules/storage"
  project_id    = "pub-sap-sbx-poc-406406"
  name          = "terraform-state-file-bucket-poc"
  location      = "us-east4"
  storage_class = "STANDARD"
  force_destroy = false
  versioning = true
}