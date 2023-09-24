# AlmaLinux 9
# ---
# Packer Template to create an AlmaLinux 9 VM on Proxmox

packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/proxmox"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

# Variable Definitions
variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

variable "vm_root_pw" {
    type = string
    sensitive = true
}

# Resource Definition for the VM Template
source "proxmox-iso" "AlmaLinux9-Template" {
    # Proxmox Connection Settings
    proxmox_url = var.proxmox_api_url
    username    = var.proxmox_api_token_id
    token       = var.proxmox_api_token_secret
    # (Optional) Skip TLS Verification
    insecure_skip_tls_verify = true

    # VM General Settings
    node                = "prdpve01"
    vm_id               = "9000"
    vm_name             = "AlmaLinux9-Template"
    template_description = "AlmaLinux 9 Minimal UEFI Image"

    # VM OS Settings
    # (Option 1) Local ISO File
    iso_file = "local:iso/AlmaLinux-9-latest-x86_64-minimal.iso"
    # - or -
    # (Option 2) Download ISO
    # iso_url = "https://almalinux.li/9/isos/x86_64/AlmaLinux-9-latest-x86_64-minimal.iso"
    # iso_checksum = "51ee8c6dd6b27dcae16d4c11d58815d6cfaf464eb0e7c75e026f8d5cc530b476"
    iso_storage_pool = "local"
    unmount_iso = true
    
    # VM System Settings
    qemu_agent = true

    bios = "ovmf"
    efi_config {
        efi_storage_pool  = "local-lvm"
        efi_type          = "4m"
        pre_enrolled_keys = true
    }

    # VM Hard Disk Settings
    scsi_controller = "virtio-scsi-pci"

    disks {
        disk_size           = "20G"
        storage_pool        = "local-lvm"
        storage_pool_type   = "lvm"
        type                = "virtio"
    }

    # VM CPU Settings
    cores = "2"
    cpu_type = "host"

    # VM Memory Settings
    memory = "2048"

    # VM Network Settings
    network_adapters {
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = "false"
    }

    # VM Cloud-Init Settings
    cloud_init             = true
    cloud_init_storage_pool = "local-lvm"

    # PACKER Boot Commands
    boot_command = [
      #"c<wait>",
      #"linuxefi /images/pxeboot/vmlinuz",
      #" inst.stage2=hd:LABEL=AlmaLinux-9-latest-x86_64-minimal ro",
      #" inst.text biosdevname=0 net.ifnames=0",
      #" inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/kickstart.cfg",
      #" inst.repo=https://repo.almalinux.org/almalinux/9/BaseOS/x86_64/os/",
      #"<wait><wait><enter>",
      #"initrdefi /images/pxeboot/initrd.img",
      #"<enter>",
      #"boot<enter><wait>"

      # Swiss-AS Boot Command
      "<up><wait>e<wait><down><wait><down><wait><end>",
      " inst.text",
      " inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg ",
      "<wait><F10>"
    ]
    boot_wait = "10s"

    # PACKER Autoinstall Settings
    http_directory = "http" 
    # (Optional) Bind IP Address and Port
    # http_bind_address = "0.0.0.0"
    http_port_min = 8802
    http_port_max = 8802

    ssh_username = "root"

    # (Option 1) Add your Password here
    ssh_password = var.vm_root_pw
    # - or -
    # (Option 2) Add your Private SSH KEY file here
    # ssh_private_key_file = "~/.ssh/id_ed25519"

    # Raise the timeout, when installation takes longer
    ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {
    name    = "AlmaLinux9-Template"
    sources = ["source.proxmox-iso.AlmaLinux9-Template"]

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox
    provisioner "shell" {
        inline = [
            #"while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
            "sudo rm -f /etc/ssh/ssh_host_*",
            "sudo rm -f /etc/udev/rules.d/70-persistent-net.rules",
            "sudo truncate -s 0 /etc/machine-id",
            "sudo dnf clean all",
            "sudo rm -rf /var/cache/dnf",
            "sudo cloud-init clean",
            "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
            "sudo rm -f /etc/netplan/00-installer-config.yaml",
            "sudo systemctl enable cloud-init",
            "sudo systemctl enable cloud-config",
            "sudo systemctl enable cloud-final",
            "sudo systemctl enable cloud-init-local",
            "sudo sync"
        ]
    }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
    # provisioner "file" {
    #     source      = "files/almalinux-9-kickstart.cfg"
    #     destination = "/tmp/almalinux-9-kickstart.cfg"
    # }

    # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
    # provisioner "shell" {
    #     inline = ["sudo cp /tmp/almalinux-9-kickstart.cfg /etc/cloud/cloud.cfg.d/almalinux-9-kickstart.cfg"]
    # }

    # Provisioning the VM Template for Ansible in Proxmox #4
    #provisioner "ansible" {
    #  playbook_file    = "./ansible/gencloud.yml"
    #  galaxy_file      = "./ansible/requirements.yml"
    #  roles_path       = "./ansible/roles"
    #  collections_path = "./ansible/collections"
    #  ansible_env_vars = [
    #    "ANSIBLE_PIPELINING=True",
    #    "ANSIBLE_REMOTE_TEMP=/tmp",
    #    "ANSIBLE_SSH_ARGS='-o ControlMaster=no -o ControlPersist=180s -o ServerAliveInterval=120s -o TCPKeepAlive=yes'"
    #  ]
    #}

    # Add additional provisioning scripts here
    # ...
}
