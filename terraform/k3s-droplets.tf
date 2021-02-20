
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




