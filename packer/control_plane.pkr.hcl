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

variable "token" {
    default = env("TOKEN")
    sensitive = true
}

variable "key" {
    default = env("KEY")
    sensitive = true
}

variable "secret" {
    default = env("SECRET")
    sensitive = true
}

source "digitalocean" "control_plane" {
  api_token = var.token
  image = "debian-13-x64"
  region = "fra1"
  size = "s-1vcpu-512mb-10gb"
  ssh_username = "root"
}

build {
    sources = ["source.digitalocean.control_plane"]

    provisioner "ansible" {
        playbook_file = "./ansible/control_plane.yaml"
    }

    post-processor "digitalocean-import" {
        api_token = var.token
        spaces_key = var.key
        spaces_secret = var.secret
        spaces_region = "fra1"
        space_name = "import-bucket"
        image_name = "control_plane"
        image_description = "Packer import {{timestamp}}"
        image_regions = ["fra1"]
    }
}