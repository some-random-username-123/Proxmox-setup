# Provider Variables
variable "proxmox_server_url" {
    description = "The URL of the server that Terraform can connect to."
    type = string
    default = "https://192.168.0.100:8006"
}

variable "proxmox_web_username" {
    description = "The user and the authentication domain that are use ONLY WHEN USING CREDENTIALS."
    type = string
    default = "root@pam"
}

variable "proxmox_ssh_username" {
    description = "The user and the authentication domain that are use ONLY WHEN USING A API TOKEN."
    type = string
    default = "root"
}

variable "proxmox_user_password" {
    description = "The user and the authentication domain that are use ONLY WHEN USING CREDENTIALS."
    type = string
}

variable "proxmox_api_token" {
    description = "The user and the authentication domain that are use ONLY WHEN USING A API TOKEN."
    type = string
}

variable "proxmox_server_ssl_insecure" {
    description = "Specifies if the Server has a invalid SSL certificate."
    type = bool
    default = true
}


##############################################

# Resource Variables

variable "vm_name" {
  description = "The Name of the VM that is created."
  type = string
}

variable "vm_description" {
  description = "The description for the new VM."
  type        = string
  default     = " Managed by Terraform "
}

variable "vm_tags" {
  description = "List of tags for the new VM."
  type        = list(string)
  default     = ["terraform", "almalinux9", "ansible_semaphore"]
}

variable "vm_id" {
  description = "The ID of the VM that is created"
  type        = number
}

variable "vm_node_name" {
  description = "The Name of the target Proxmox node."
  type        = string
  default     = "prdpve01"
}

variable "vm_datastore_id" {
  description = "The target datastore for the clone."
  type        = string
  default     = "local-lvm"
}

variable "vm_start" {
  description = "Specifies if the VM starts immediately after creation."
  type        = bool
  default     = true
}

variable "vm_start_on_boot" {
  description = "Specifies if the VM starts up after the node booted."
  type        = bool
  default     = false
}

variable "vm_startup_order" {
    description = "The Order in which the VMs start up after the node rebooted."
    type = number
    default = 0
}

variable "vm_up_down_delay" {
    description = "The delay of the power cycles of the VM and the host."
    type = number
    default = 30
}

variable "vm_template_node_name" {
    description = "The name of the node where the template is stored."
    type = string
    default = "prdpve01"
}

variable "vm_ci_interface" {
    description = "The Interface for the Cloudinit drive on the VM."
    type = string
    default = "ide0"
}

variable "vm_template_id" {
    description = "The VM ID of the Template that will be cloned."
    type = number
    default = 9000
}

variable "vm_ip_address" {
    description = "The IP adress that the VM has. (use 'dhcp' for automatic IP)"
    type = string
    default = "dhcp"
}

variable "vm_ip_gateway" {
    description = "The IP of the gateway that the VM uses. (when vm_ip_address = 'dhcp' no gateway is used)"
    type = string
    default = ""
}

variable "vm_sa_user_name" {
    description = "The username of the service account that is used on this VM."
    type = string
    default = "sa_ansible"
}

variable "vm_sa_user_password" {
    description = "The password of the service account that is used on this VM."
    type = string
    sensitive = true
}

variable "vm_sa_user_ssh_keys" {
    description = "The ssh key(s) of the service account that is used on this VM."
    type = list(string)
    sensitive = true
}

variable "vm_network_devices" {
  description = "The network device(s) for this VM."
  default = [
    {
        bridge          = "vmbr0"
        enabled         = true
        firewall        = false
        model           = "virtio"
        vlan_id         = null
    }
  ]
}

variable "vm_disks" {
  description = "The virtual disk(s) for this VM."
  default = [
    { 
      datastore_id  = "local-lvm" 
      file_format   = "raw" 
      interface     = "scsi0" 
      size          = "32" 
      ssd           = false 

    }
  ]
}


##############################################

# Local Variables

locals {
  vm_all_tags = concat(var.vm_tags, ["terraform", "almalinux9", "ansible_semaphore"])
  vm_full_description = replace(var.vm_description, "^(?!.*Managed by Terraform & Ansible Semaphore).*", "${var.vm_description} Managed by Terraform & Ansible Semaphore")
}
