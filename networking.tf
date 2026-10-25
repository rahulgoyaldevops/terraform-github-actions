# ============================================================================
# Production Virtual Network & Network Security Group
# ============================================================================

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-github-demo-prod"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.200.0.0/16"]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform-GitHubActions"
    CostCenter  = "DevOps-Core"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-workloads-01"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.200.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-workloads-prod"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "DenyAllInboundInternet"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}