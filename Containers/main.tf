provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaks"

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  agent_pool_profile {
    name       = "agentpool"
    count      = 3
    vm_size    = "Standard_DS2_v2"
    os_type    = "Linux"
    mode       = "System"
  }

  service_principal {
    client_id     = "<your-client-id>"
    client_secret = "<your-client-secret>"
  }

  tags = {
    environment = "Production"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config[0].raw_kube_config
}
