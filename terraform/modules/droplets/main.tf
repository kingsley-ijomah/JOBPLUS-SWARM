terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.32.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "nodes" {
  description = "Map of node configurations"
  type = map(object({
    role  : string
    image : string
    size  : string
  }))
  default = {
    "manager" = {
      role  = "manager"
      image = "ubuntu-23-10-x64"
      size  = "s-2vcpu-4gb-120gb-intel"
    },
    "worker1" = {
      role  = "worker"
      image = "ubuntu-23-10-x64"
      size  = "s-2vcpu-4gb-120gb-intel"
    },
    "worker2" = {
      role  = "worker"
      image = "ubuntu-23-10-x64"
      size  = "s-2vcpu-4gb-120gb-intel"
    }
  }
}

resource "digitalocean_droplet" "node" {
  for_each   = var.nodes
  name       = "${var.app_name}-${each.key}-droplet"
  image      = each.value.image
  size       = each.value.size
  region     = var.do_region
  ssh_keys   = [var.ssh_fingerprint]

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-add-repository --yes ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt-get install -y ansible",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_key)
      host        = self.ipv4_address
    }
  }
}