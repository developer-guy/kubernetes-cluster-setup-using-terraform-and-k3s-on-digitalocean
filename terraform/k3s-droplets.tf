resource "digitalocean_droplet" "k3s-master" {
  image = "ubuntu-20-04-x64"
  name = "k3s-master"
  region = "fra1"
  size = "s-1vcpu-1gb"
  private_networking = true
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "local-exec" {
    command = <<-EOF
    do-ansible-inventory > ../ansible/hosts.ini
    EOF
  }
}
