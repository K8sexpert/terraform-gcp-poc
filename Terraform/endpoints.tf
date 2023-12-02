resource "google_compute_global_address" "sap_poc_endpoint" {
  project = "pub-sap-sbx-poc-406406"
  name = "sap-poc-ip"
  address_type = "EXTERNAL"
  description = "Public IP reservation for GKE cluster"
  
}

resource "google_endpoints_service" "openapi_service" {
  service_name   = "sap-poc.endpoints.pub-sap-sbx-poc-406406.cloud.goog"
  project        = "pub-sap-sbx-poc-406406"
  openapi_config = <<EOT
    swagger: "2.0"
    info:
        title: "sap-poc"
        description: "sap poc domain registration"
        version: "1.0.0"
    host: "sap-poc.endpoints.pub-sap-sbx-poc-406406.cloud.goog"
    x-google-endpoints:
        - name: "sap-poc.endpoints.pub-sap-sbx-poc-406406.cloud.goog"
          target: "${google_compute_global_address.sap_poc_endpoint.address}"
    paths:
        "/echo":
            get:
                operationId: echo
                responses:
                    200:
                        description: "OK"
                security:
                    - api_key: []
  EOT
}
