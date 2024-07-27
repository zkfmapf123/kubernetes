
output "id" {
  value = module.network.vpc.vpc_id
}

output "public_subnets" {
  value = values(module.network.vpc.webserver_subnets)
}

output "private_subnets" {
  value = values(module.network.vpc.was_subnets)
}
