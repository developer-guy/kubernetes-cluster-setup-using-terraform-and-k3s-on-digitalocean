resource "digitalocean_loadbalancer" "k3s-lb" {
  name   = "k3s-loadbalancer"
  region = "fra1"

  forwarding_rule {
    tls_passthrough = true
    entry_port     = 6443
    entry_protocol = "https"

    target_port     = 6443
    target_protocol = "https"
  }

  healthcheck {
    port     = 6443
    protocol = "tcp"
  }
 
  droplet_tag = "master"
}
