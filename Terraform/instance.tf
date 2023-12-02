resource "google_service_account_iam_member" "gce-default-account-iam" {
  service_account_id = "projects/pub-sap-sbx-poc-406406/serviceAccounts/sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
}

resource "google_service_account_iam_member" "gce-default-account-iam-user" {
  service_account_id = "projects/pub-sap-sbx-poc-406406/serviceAccounts/sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  member             = "user:parthasaradhiv.2321@gmail.com"
}

resource "google_service_account_iam_member" "workload_identity_binding_sa" {
  service_account_id = "projects/pub-sap-sbx-poc-406406/serviceAccounts/sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:pub-sap-sbx-poc-406406.svc.id.goog[default/ksa-terraform]"
}

resource "google_compute_instance" "sap-vm" {
  project      = "pub-sap-sbx-poc-406406"
  name         = "sap-poc-instance"
  machine_type = "e2-small"

  tags         = ["instance"]

  network_interface {
    network    = "sap-poc-vpc"
    subnetwork = "private-subnet-01"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  zone = "us-east4-a"
  service_account {
    email  = "sa-terraform@pub-sap-sbx-poc-406406.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  depends_on = [module.network.subnets]
}