terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.44"
    }
  }
  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}

# ------------------------------
# Resource Group
# ------------------------------
resource "azurerm_resource_group" "rg_securenetwork" {
  name     = "Secure-Network"
  location = "CanadaCentral"
}

# ------------------------------
# Virtual Network 1
# ------------------------------
resource "azurerm_virtual_network" "vnet1" {
  name                = "Peer1_vnet"
  location            = azurerm_resource_group.rg_securenetwork.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.rg_securenetwork.name
}

resource "azurerm_subnet" "sn1" {
  name                 = "peer1_subnet"
  resource_group_name  = azurerm_resource_group.rg_securenetwork.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}

# ------------------------------
# Virtual Network 2
# ------------------------------
resource "azurerm_virtual_network" "vnet2" {
  name                = "Peer2_vnet"
  location            = azurerm_resource_group.rg_securenetwork.location
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.rg_securenetwork.name
}

resource "azurerm_subnet" "sn2" {
  name                 = "peer2_subnet"
  resource_group_name  = azurerm_resource_group.rg_securenetwork.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
}

# ------------------------------
# VNet Peering: vnet1 -> vnet2
# ------------------------------
resource "azurerm_virtual_network_peering" "peer1_to_peer2" {
  name                         = "peer1-to-peer2"
  resource_group_name          = azurerm_resource_group.rg_securenetwork.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  allow_virtual_network_access = true
}

# ------------------------------
# VNet Peering: vnet2 -> vnet1
# ------------------------------
resource "azurerm_virtual_network_peering" "peer2_to_peer1" {
  name                         = "peer2-to-peer1"
  resource_group_name          = azurerm_resource_group.rg_securenetwork.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  allow_virtual_network_access = true
}
