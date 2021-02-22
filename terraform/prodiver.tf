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
variable "database_user" {}

variable "nodes" {
  type = set(object({
    name = string
    tag  = string
  }))
  default = [
    {
      name = "master1"
      tag  = "master"
    },
    {
      name = "master2",
      tag  = "master"
    },
    {
      name = "agent1",
      tag  = "agent"
      }, {
      name = "agent2",
      tag  = "agent"
    },
    {
      name = "agent3",
      tag  = "agent"
    }
  ]
}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "Batuhan-MBP"
}
