package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
  // "github.com/gruntwork-io/terratest/modules/gcp"

)

func TestTerraform(t *testing.T) {
  // Configure Terratest to use your Terraform code

  projectId := "pub-sap-sbx-poc-406406"
  vpc_name := "test-vpc"
  auto_Create_Subnetworks := "false"
  terraformOptions := &terraform.Options{
    TerraformDir: "./modules/network",
    
    Vars: map[string]interface{}{
      "project_id": projectId,
      "vpc_name": vpc_name,
      "auto_create_subnetworks": auto_Create_Subnetworks,
    },

  }

  // Run 'terraform init' and 'terraform apply', and defer 'terraform destroy' to clean up after the test
  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  // Retrieve output variables from the Terraform state
  output := terraform.Output(t, terraformOptions, "output_name")

  // Perform assertions on the output variables
  assert.Equal(t, "expected_output_value", output)
}