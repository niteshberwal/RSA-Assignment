# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "my-vnet"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "my-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Public IP for Bastion
resource "azurerm_public_ip" "bastion_ip" {
  name                = "bastion-public-ip"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# App Service Plan for Function App
resource "azurerm_app_service_plan" "service_plan" {
  name                = "my-app-service-plan"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Storage Account for Function App
resource "azurerm_storage_account" "storage_account" {
  name                     = "mystorageaccount"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = "East US"
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

# Function App
resource "azurerm_function_app" "function_app" {
  name                = "my-function-app"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.service_plan.id
  storage_account_name = azurerm_storage_account.storage_account.name
  os_type             = "Linux"
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
    "FUNCTIONS_EXTENSION_VERSION" = "~4"
  }
}

# Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                     = "my-bastion"
  location                 = "East US"
  resource_group_name      = azurerm_resource_group.rg.name
  dns_name                 = "mybastion"
  virtual_network_id       = azurerm_virtual_network.vnet.id
  public_ip_address_id     = azurerm_public_ip.bastion_ip.id
}

# Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg" {
  name                = "my-nsg"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Route Table
resource "azurerm_route_table" "route_table" {
  name                = "my-route-table"
  location            = "East US"
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "AppConnectionRoute"
    address_prefix         = "10.0.0.0/24"
    next_hop_type          = "VirtualNetworkGateway"
  }
}
