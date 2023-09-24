variable "proxmox_server_url" {
    type = string
}

variable "proxmox_web_username" {
    type = string
}

variable "proxmox_ssh_username" {
    type = string
}

variable "proxmox_user_password" {
    type = string
}

variable "proxmox_api_token" {
    type = string
}

variable "proxmox_server_ssl_insecure" {
    type = bool
}

variable "vm_sa_user_password" {
    type = string
}

variable "vm_sa_user_ssh_keys" {
    type = list(string)
}
