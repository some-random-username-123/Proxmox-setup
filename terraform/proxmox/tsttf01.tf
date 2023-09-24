module "tsttf01" {
    source = "../modules/proxmox/almalinux9-basic"

    proxmox_server_url          = var.proxmox_server_url
    proxmox_web_username        = var.proxmox_web_username
    proxmox_ssh_username        = var.proxmox_ssh_username
    proxmox_user_password       = var.proxmox_user_password
    proxmox_api_token           = var.proxmox_api_token
    proxmox_server_ssl_insecure = var.proxmox_server_ssl_insecure

    vm_name                 = "tsttf02"
    vm_description          = "Test VM for tf module. "
    vm_tags                 = ["tst"]
    vm_id                   = 1001
    vm_ci_interface         = "ide0"
    vm_template_id          = 9001
    vm_ip_address           = "dhcp"
    vm_disks                = []
    vm_start                = false
    va_start_on_boot        = false

    vm_sa_user_password     = var.vm_sa_user_password
    vm_sa_user_ssh_keys     = var.vm_sa_user_ssh_keys
}