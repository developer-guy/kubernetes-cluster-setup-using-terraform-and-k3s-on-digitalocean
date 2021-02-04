output "postgresql_database_password" {
  value = digitalocean_database_user.dbuser.password
}
