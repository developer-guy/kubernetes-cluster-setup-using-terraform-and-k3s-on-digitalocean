resource "digitalocean_database_user" "dbuser" {
  cluster_id = digitalocean_database_cluster.postgres.id
  name       = var.database_user
}


resource "digitalocean_database_cluster" "postgres" {
  name       = "k3s-backend-store"
  engine     = "pg"
  version    = "11"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}
