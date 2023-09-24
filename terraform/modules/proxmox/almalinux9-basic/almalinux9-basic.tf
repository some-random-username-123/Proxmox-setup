resource "proxmox_virtual_environment_vm" "almalinux9-basic" {
  name              = var.vm_name
  vm_id             = var.vm_id

  description       = local.vm_full_description
  tags              = local.vm_all_tags

  started           = var.vm_start
  on_boot           = var.vm_start_on_boot

  node_name         = var.vm_node_name

  agent {
    enabled         = true
  }

  startup {
    order           = var.vm_startup_order
    up_delay        = var.vm_up_down_delay
    down_delay      = var.vm_up_down_delay
  }

  clone {
    datastore_id    = var.vm_datastore_id
    node_name       = var.vm_template_node_name
    vm_id           = var.vm_template_id
  }

  initialization {
    interface       = var.vm_ci_interface

    ip_config {
      ipv4 {
        address     = var.vm_ip_address
        gateway     = var.vm_ip_address == "dhcp" ? null : var.vm_ip_gateway
      }
    }

    user_account {
      username      = var.vm_sa_user_name
      password      = var.vm_sa_user_password
      keys          = var.vm_sa_user_ssh_keys
    }
  }

  keyboard_layout   = "de-ch"

  dynamic "network_device" {
    for_each    = [for nd in var.vm_network_devices: {
      bridge        = nd.bridge  
      enabled       = nd.enabled  
      firewall      = nd.firewall  
      model         = nd.model
      vlan_id       = nd.vlan_id 
    }]  
    content {
      bridge        = network_device.value.bridge
      enabled       = network_device.value.enabled
      firewall      = network_device.value.firewall
      model         = network_device.value.model
      vlan_id       = network_device.value.vlan_id
    }
  }

  dynamic "disk" {
    for_each    = [for d in var.vm_disks: {
      datastore_id  = d.datastore_id
      file_format   = d.file_format
      interface     = d.interface
      size          = d.size
      ssd           = d.ssd
    }]  
    content {
      datastore_id  = disk.value.datastore_id
      file_format   = disk.value.file_format
      interface     = disk.value.interface
      size          = disk.value.size
      ssd           = disk.value.ssd
      }
  }
}
