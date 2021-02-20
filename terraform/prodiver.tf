terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }

  backend "remote" {
    organization = "devquy"
  
    workspaces {
      name = "digitalocean"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}
variable "database_user"{}
variable "master_names" {
  type = set(string)
  default = ["master1","master2"]
}

variable "agent_names" {
  type = set(string)
  default = ["node1", "node2", "node3"]
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "Batuhan-MBP"
}
