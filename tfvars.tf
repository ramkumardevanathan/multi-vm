variable "subscriptionId" {}
variable "clientId" {}
variable "clientSecret" {}
variable "resourceGroup" {}
variable "azure_tenant_id" {}
variable "instances" {}
variable "nb_disks_per_instance" {}

provider "azurerm" {
  subscription_id = var.subscriptionId
  client_id       = var.clientId
  client_secret   = var.clientSecret
  tenant_id       = var.azure_tenant_id
  features {}
}
