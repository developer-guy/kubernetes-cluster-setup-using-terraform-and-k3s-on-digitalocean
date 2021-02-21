![ansible_terraform_k3s](./assets/ansible_terraform_k3s.png)

# Set up HA k3s cluster on DigitalOcean using Terraform + Ansible

This demo aims to emonstrate how we can use set up your our Kubernetes cluster using lightweight Kubernetes distribution called [k3s](https://k3s.io) on DigitalOcean using IAC principle with [Terraform](https://www.terraform.io) and [Ansible](https://www.ansible.com).

# Table of contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
- 🎁 [What's in it for you?](#whats-in-it-for-you)
- 🎯 [Which audience are we targeting ?](#which-audience-are-we-targeting-)
- 🧰 [Prerequisites](#prerequisites)
- <img src="https://cncf-branding.netlify.app/img/projects/k3s/horizontal/color/k3s-horizontal-color.svg" height="16" width="16"/> [What is k3s ?](#what-is-k3s-)
- 🤔 [What is IAC(Infrastructure As Code) principle ?](#what-is-iacinfrastructure-as-code-principle-)
- <img src="https://symbols-electrical.getvecta.com/stencil_97/45_terraform-icon.d8dd637866.svg" height="16" width="16"/>[What is Terraform ?](#what-is-terraform-)
- <img src="https://symbols-electrical.getvecta.com/stencil_97/45_terraform-icon.d8dd637866.svg" height="16" width="16"/>[What is Terraform Cloud ?](#what-is-terraform-cloud-)
- ⚙️ [How can you write a terraform configuration files ?](#how-can-you-write-a-terraform-configuration-files-)
- <img src="https://symbols-electrical.getvecta.com/stencil_73/122_ansible-icon.e1db432c74.svg" height="16" width="16"/>[What is Ansible ?](#what-is-ansible-)
- <img src="https://symbols-electrical.getvecta.com/stencil_73/122_ansible-icon.e1db432c74.svg" height="16" width="16"/>[What is Ansible Roles ?](#what-is-ansible-roles-)
- 🤔 [How can you write a playbook to automate things on the VM's ?](#how-can-you-write-a-playbook-to-automate-things-on-the-vms-)
- 👨‍💻[Hands On](#hands-on)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# What's in it for you?
* What is k3s ?
* What is IAC(Infrastructure As Code) principle ?
* What is Terraform ?
* What is Terraform Cloud ?
* What is Ansible ?
* What is Ansible Roles ?
* Hands On

# Which audience are we targeting ?

* If you are a developer and wants to set up a lighweight Kubernetes cluster for demo purposes.
* If you are curious about k3s and wants to try it out on a cloud such as DigitalOcean.
* If you are a DevOps team member and wants to learn how you can set up k3s a lighweight Kubernetes cluster with HA(Highly Available) mode on DigitalOcean.
* If you are a System engineer and wants to learn how to automate a setting up k3s cluster using Ansible roles.

You are at the right place. 👌

# Prerequisites

* <img src="https://cdn.svgporn.com/logos/digital-ocean.svg" height="16" width="16"/> DigitalOcean Account
* <img src="https://symbols-electrical.getvecta.com/stencil_97/45_terraform-icon.d8dd
637866.svg" height="16" width="16"> Terraform Cloud
* <img src="https://symbols-electrical.getvecta.com/stencil_97/45_terraform-icon.d8dd637866.svg" height="16" width="16"/> Terraform v0.14.7
* <img src="https://symbols-electrical.getvecta.com/stencil_73/122_ansible-icon.e1db432c74.svg" height="16" width="16"/> Ansible 2.10.5

> I'm going to do this demo on my macOS Catalina 1.15.7, if you are on the same environment, you can use [brew](https://brew.sh) which is a package manager for macOS to setup all the tools that we mention above.

# What is k3s ?
K3s is a fully compliant Kubernetes distribution with the following enhancement:

* Packaged as a single binary.
* Lightweight storage backend based on sqlite3 as the default storage mechanism. etcd3, MySQL, Postgres also still available.
* Wrapped in simple launcher that handles a lot of the complexity of TLS and options.
* Secure by default with reasonable defaults for lightweight environments.
* Simple but powerful “batteries-included” features have been added, such as: a local storage provider, a service load balancer, a Helm controller, and the Traefik ingress controller.
* Operation of all Kubernetes control plane components is encapsulated in a single binary and process. This allows K3s to automate and manage complex cluster operations like distributing certificates.
* External dependencies have been minimized (just a modern kernel and cgroup mounts needed). K3s packages required dependencies, including:
  * containerd
  * Flannel
  * CoreDNS
  * CNI
  * Host utilities (iptables, socat, etc)
  * Ingress controller (traefik)
  * Embedded service loadbalancer
  * Embedded network policy controller

> Credit: https://rancher.com/docs/k3s/latest/en/
# What is IAC(Infrastructure As Code) principle ?
Infrastructure as code is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.

> Credit: https://en.wikipedia.org/w/index.php?title=Infrastructure_as_code&oldid=903249795

# What is Terraform ?
Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files.

> Credit: https://www.terraform.io

# What is Terraform Cloud ?
Terraform Cloud is an application that helps teams use Terraform together. It manages Terraform runsin a consistent and reliable environment, and includes easy access to shared state and secret data, access controls for approving changes to infrastructure, a private registry for sharing Terraform modules, detailed policy controls for governing the contents of Terraform configurations, and more.

> Credit: https://www.terraform.io/docs/cloud/index.html#about-terraform-cloud-and-terraform-enterprise

# What is Ansible ?
Ansible is a software tool that provides simple but powerful automation for cross-platform computer support. It is primarily intended for IT professionals, who use it for application deployment, updates on workstations and servers, cloud provisioning, configuration management, intra-service orchestration, and nearly anything a systems administrator does on a weekly or daily basis.

> Credit: https://opensource.com/resources/what-ansible

# What is Ansible Roles ?
Roles let you automatically load related vars_files, tasks, handlers, and other Ansible artifacts based on a known file structure. Once you group your content in roles, you can easily reuse them and share them with other users.

> Credit: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html

# Hands On
In this demo, we are going to set up highly available k3s cluster. We are going provision a 2 master node node behind the LB(LoadBalancer) to provide HA support and 3 worker nodes, if you are not familiar about these terms, please go to the [official documentation of Kubernetes](https://kubernetes.io) and learn the meainings of them before continue. After provision the nodes, we'll use the Ansible as local provisioner for our VMs. In Ansible, we'll use the Ansible Role called ['xanmanning.k3s'](https://galaxy.ansible.com/xanmanning/k3s) to automate the installation of k3s onto the master and workers node.

> NOTE: We are going to use Terraform Cloud as a Terraform Backend to store our Terraform state, before you getting started, please go the following [link](https://www.terraform.io/docs/cli/config/config-file.html#credentials-1) and configure your terraform cli to be able to store state file in the Terraform Cloud.

Lets start with our [provider.tf](./terraform/provider.tf) file that includes our provider and variables definitions.
```tf
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }

  backend "remote" {
    organization = "my-organization"
  
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
  name = "our-ssh-key"
}

```

You should notice that we are using DigitalOcean as a provider and bunch of configuration variables. You can refer to the [link](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs) for getting more detail about DigitalOcean provider.

Lets continue with [k3s-droplets.tf](./terraform/k3s-droplets.tf) which includes the definitions of our VMs called droplets in DigitalOcean world.
```tf
resource "digitalocean_droplet" "k3s-master" {
   for_each = var.master_names

  image = "ubuntu-20-04-x64"
  name = each.key
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  tags = [ each.key, "k3s_master"]

  provisioner "remote-exec" {
   inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

   connection {
     host        = self.ipv4_address
     type        = "ssh"
     user        = "root"
     private_key = file(var.pvt_key)
    }
  }
  

 provisioner "local-exec" {
   working_dir = "${path.cwd}/../ansible"
   command = <<-EOF
   do-ansible-inventory --group-by-tag > hosts.ini
   ansible-playbook setup_cluster_playbook.yaml -u root --private-key ~/.ssh/digitalocean_rsa --extra-vars "loadbalancer_ip=${digitalocean_loadbalancer.k3s-master-lb.ip} database_host=${digitalocean_database_cluster.postgres.host} database_user=admin database_password=${digitalocean_database_user.dbuser.password} database_name=${digitalocean_database_cluster.postgres.database} database_port=${digitalocean_database_cluster.postgres.port}"
 EOF
 }
 
  depends_on = [ digitalocean_database_cluster.postgres, digitalocean_droplet.k3s-agent ]
}

resource "digitalocean_droplet" "k3s-agent" {
   for_each = var.agent_names

  image = "ubuntu-20-04-x64"
  name = each.key
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  tags = [ each.key, "k3s_agent"]

  provisioner "remote-exec" {
   inline = ["sudo apt update", "sudo apt install python3 -y", "echo Done!"]

   connection {
     host        = self.ipv4_address
     type        = "ssh"
     user        = "root"
     private_key = file(var.pvt_key)
    }
  }
  
 }

```

