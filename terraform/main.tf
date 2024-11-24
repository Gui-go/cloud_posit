locals {
  proj_name    = "cloud_posit"
  proj_id      = "cloud_posit1"
  location     = "us-west4"
  zone         = "us-west4-b"
  tag_owner    = "guilhermeviegas"
}

module "network" {
  source    = "./modules/network"
  proj_name = local.proj_name
  proj_id   = local.proj_id
  location  = local.location
  zone      = local.zone
  tag_owner = local.tag_owner
}

module "compute" {
  source            = "./modules/compute"
  proj_name         = local.proj_name
  proj_id           = local.proj_id
  location          = local.location
  machine_type      = "n1-standard-4"
  tag_owner         = local.tag_owner
  network_name      = module.network.vpc_network_name
  gpu_enabled       = false
}

