resource "azurerm_public_ip" "pip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.nsg_source_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "vm-nic-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}


resource "azurerm_network_interface_security_group_association" "sg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_password" "adminpassword" {
  keepers = {
    resource_group = var.resource_group
  }

  length      = 10
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

# Create (and display) an SSH key
resource "tls_private_key" "ssh_config" {
  algorithm = "RSA"
  rsa_bits = 4096
}



resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm_name
  location                        = var.location
  resource_group_name             = var.resource_group
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = "Standard_DS1_v2"
  computer_name                   = var.computer_name
  admin_username                  = var.vm_admin_user
  admin_password                  = var.vm_admin_password
  disable_password_authentication = var.disable_password_authentication

  os_disk {
    name                 = var.vm_os_disk_name
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username       = var.vm_admin_user
    public_key     = tls_private_key.ssh_config.public_key_openssh
  }

  provisioner "remote-exec" {
    connection {
      host     = self.public_ip_address
      type     = "ssh"
      private_key = tls_private_key.ssh_config.private_key_pem
      user     = var.vm_admin_user
      password = var.vm_admin_password
    }

    inline = [
      "sudo apt-get update && sudo apt-get install -y apt-transport-https gnupg2 wget curl jq ansible git unzip ca-certificates"
    ]
  }
}
