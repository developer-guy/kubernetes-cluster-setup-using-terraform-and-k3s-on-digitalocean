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
variable "postgresql_username"{}
variable "postgresql_password"{}


provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "Batuhan-MBP"
}
