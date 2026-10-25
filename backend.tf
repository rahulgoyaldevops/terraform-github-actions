# ============================================================================
# Terraform Remote State Backend with Azure Storage Blob Leases
# Engineering Lead: Rahul Goyal
# ============================================================================

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-tfstate-mgmt"
    storage_account_name = "sttfstatelzprod01"
    container_name       = "tfstate-prod"
    key                  = "github-actions.terraform.tfstate"
    use_oidc             = true
  }
}