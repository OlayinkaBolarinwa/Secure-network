# ------------------------------
# Peer1 Public IP
# ------------------------------
resource "azurerm_public_ip" "peer1_pub" {
  name                = "peer1-public-ip"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ------------------------------
# Peer1 NSG (allow SSH)
# ------------------------------
resource "azurerm_network_security_group" "peer1_nsg" {
  name                = "peer1-nsg"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name

  security_rule {
    name                      = "AllowSSH"
    priority                  = 1001
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ------------------------------
# Peer1 NIC
# ------------------------------
resource "azurerm_network_interface" "peer1_nic" {
  name                = "peer1-nic"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name

  ip_configuration {
    name                          = "peer1-ipconfig"
    subnet_id                     = azurerm_subnet.sn1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.peer1_pub.id
  }
}

# ------------------------------
# Peer1 NIC NSG association
# ------------------------------
resource "azurerm_network_interface_security_group_association" "peer1_nic_nsg" {
  network_interface_id      = azurerm_network_interface.peer1_nic.id
  network_security_group_id = azurerm_network_security_group.peer1_nsg.id
}

# ------------------------------
# Peer1 VM
# ------------------------------
resource "azurerm_virtual_machine" "peer1_vm" {
  name                  = "peer1-vm"
  location              = azurerm_resource_group.rg_securenetwork.location
  resource_group_name   = azurerm_resource_group.rg_securenetwork.name
  network_interface_ids = [azurerm_network_interface.peer1_nic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "peer1-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "peer1-host"
    admin_username = "testadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/testadmin/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = {
    environment = "staging"
  }
}

# ------------------------------
# Peer2 Public IP
# ------------------------------
resource "azurerm_public_ip" "peer2_pub" {
  name                = "peer2-public-ip"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# ------------------------------
# Peer2 NSG (allow SSH)
# ------------------------------
resource "azurerm_network_security_group" "peer2_nsg" {
  name                = "peer2-nsg"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name

  security_rule {
    name                      = "AllowSSH"
    priority                  = 1001
    direction                 = "Inbound"
    access                    = "Allow"
    protocol                  = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ------------------------------
# Peer2 NIC
# ------------------------------
resource "azurerm_network_interface" "peer2_nic" {
  name                = "peer2-nic"
  location            = azurerm_resource_group.rg_securenetwork.location
  resource_group_name = azurerm_resource_group.rg_securenetwork.name

  ip_configuration {
    name                          = "peer2-ipconfig"
    subnet_id                     = azurerm_subnet.sn2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.peer2_pub.id
  }
}

# ------------------------------
# Peer2 NIC NSG association
# ------------------------------
resource "azurerm_network_interface_security_group_association" "peer2_nic_nsg" {
  network_interface_id      = azurerm_network_interface.peer2_nic.id
  network_security_group_id = azurerm_network_security_group.peer2_nsg.id
}

# ------------------------------
# Peer2 VM
# ------------------------------
resource "azurerm_virtual_machine" "peer2_vm" {
  name                  = "peer2-vm"
  location              = azurerm_resource_group.rg_securenetwork.location
  resource_group_name   = azurerm_resource_group.rg_securenetwork.name
  network_interface_ids = [azurerm_network_interface.peer2_nic.id]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "peer2-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "peer2-host"
    admin_username = "testadmin"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/testadmin/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = {
    environment = "staging"
  }
}
