
resource "azurerm_linux_virtual_machine" "vm" {
  count                 = length(var.instances)
  name                  = element(var.instances, count.index)
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_D2s_v3"
  network_interface_ids = [element(azurerm_network_interface.nic.*.id, count.index)]
  admin_username        = "adminuser"
  admin_password        = "Password1234!@"

  disable_password_authentication = false

  os_disk {
    name                 = "osdisk-${element(var.instances, count.index)}-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "managed_disk" {
  count                = length(var.instances) * var.nb_disks_per_instance
  name                 = element(var.instances, count.index)
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
  tags                 = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "managed_disk_attach" {
  count              = length(var.instances) * var.nb_disks_per_instance
  managed_disk_id    = azurerm_managed_disk.managed_disk.*.id[count.index]
  virtual_machine_id = azurerm_linux_virtual_machine.vm.*.id[ceil((count.index + 1) * 1.0 / var.nb_disks_per_instance) - 1]
  lun                = count.index + 10
  caching            = "ReadWrite"
}

