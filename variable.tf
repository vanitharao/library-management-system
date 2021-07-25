terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.62.0"
    }
  }
}

provider "azurerm" {
 features {}
}
# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "example" {
    name     = "blueeyes"
    location = "eastus"

    tags = {
        environment = "Terraform Demo"
    }
}

# Create virtual network
resource "azurerm_virtual_network"  "example" {
    name                = "myVnet"
    address_space       = ["11.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.example.name

    tags = {
        environment = "Terraform Demo"
    }
}

# Create subnet
resource "azurerm_subnet"  "example"  {
    name                 = "mySubnet"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes      = ["11.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "example"{
    name                         = "myPublicIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.example.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}





# Create network interface
resource "azurerm_network_interface"  "example"{
    name                      = "myNIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.example.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.example.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.example.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# Connect the security group to the network interface


# Generate random text for a unique storage account name




# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem 
    sensitive = true

 }

# Create virtual machine
resource "azurerm_linux_virtual_machine"  "example"{
    name                  = "myVM"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.example.name
    network_interface_ids = [azurerm_network_interface.example.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    disable_password_authentication = true
        
    admin_ssh_key {
        username       = "azureuser"
        public_key     = tls_private_key.example_ssh.public_key_openssh
    }

   

    tags = {
        environment = "Terraform Demo"
    }
}
