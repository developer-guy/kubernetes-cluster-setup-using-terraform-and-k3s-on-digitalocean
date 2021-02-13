resource "digitalocean_droplet" "k3s-master" {
  image = "ubuntu-20-04-x64"
  name = "k3s-master"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  tags = [ "k3s_master" ]

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
   working_dir = "../ansible"
   command = <<-EOF
   do-ansible-inventory --group-by-tag > hosts.ini
   ansible-playbook playbook.yaml -u root --private-key ~/.ssh/digitalocean_rsa --extra-vars "database_host=${digitalocean_database_cluster.postgres.host} database_user=admin database_password=${digitalocean_database_user.dbuser.password} database_name=${digitalocean_database_cluster.postgres.database} database_port=${digitalocean_database_cluster.postgres.port}"
 EOF
 }
 
  depends_on = [ digitalocean_database_cluster.postgres ]
}
