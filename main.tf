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

// copies over the public key to digitalocean
resource "digitalocean_ssh_key" "prod_ssh_key" {
  name       = "${var.app_name}-ssh-key"
  public_key = file("${var.ssh_key}.pub")
}

# DigitalOcean Droplet for Manager Node
resource "digitalocean_droplet" "manager_node" {
  name    = "${var.app_name}-manager-droplet"
  image   = "${var.do_image}"
  size    = "${var.do_size}"
  region  = "${var.do_region}"
  ssh_keys = [var.ssh_fingerprint]
}

# DigitalOcean Droplet for worker1 Node
resource "digitalocean_droplet" "worker1_node" {
  name    = "${var.app_name}-worker-droplet"
  image   = "${var.do_image}"
  size    = "${var.do_size}"
  region  = "${var.do_region}"
  ssh_keys = [var.ssh_fingerprint]
}