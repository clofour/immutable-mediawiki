packer {
    required_plugins {
        digitalocean = {
            version = ">= 1.0.4"
            source = "github.com/digitalocean/digitalocean"
        }
        ansible = {
            version = "~> 1"
            source = "github.com/hashicorp/ansible"
        }
    }
}

variable "do_api_token" {
    default = env("DIGITALOCEAN_API_TOKEN")
    sensitive = true
}

source "digitalocean" "worker" {
  api_token = var.do_api_token
  image = "debian-13-x64"
  region = "fra1"
  size = "s-1vcpu-512mb-10gb"
  ssh_username = "root"
}

build {
    sources = ["source.digitalocean.worker"]

    provisioner "ansible" {
        playbook_file = "./ansible/worker.yaml"
    }
}