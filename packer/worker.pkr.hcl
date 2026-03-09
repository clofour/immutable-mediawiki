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

source "digitalocean" "worker" {
  api_token = "{{env `token`}}"
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

    post-processor "digitalocean-import" {
        api_token = "{{env `token`}}"
        spaces_key = "{{env `key`}}"
        spaces_secret = "{{env `secret`}}"
        spaces_region = "fra1"
        space_name = "import-bucket"
        image_name = "worker"
        image_description = "Packer import {{timestamp}}"
        image_regions = ["fra1"]
    }
}