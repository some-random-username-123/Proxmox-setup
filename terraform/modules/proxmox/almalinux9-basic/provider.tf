provider "proxmox" {
  endpoint  = var.proxmox_server_url
  insecure  = var.proxmox_server_ssl_insecure


# Authentication via API TOKEN
  api_token = var.proxmox_api_token
  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }

# Authentication via Credentials
  #username = var.proxmox_web_username
  #password = var.proxmox_user_password 
}
