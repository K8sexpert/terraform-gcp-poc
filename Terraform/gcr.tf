resource "google_container_registry" "gcr" {
    project = "pub-sap-sbx-poc-406406"
  
}

resource "google_storage_bucket_iam_member" "gcr_access" {
    bucket = google_container_registry.gcr.id
    role   = "roles/storage.objectAdmin"
    member = "user:parthasaradhiv.2321@gmail.com"
}