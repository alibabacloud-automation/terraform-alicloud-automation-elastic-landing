module "kubernetes" {
  source                = "./infrastructure"
  region                = var.region
  availability_zones    = var.zone_ids
  environment           = var.environment
  enable_service        = var.enable_service
  new_vpc               = var.new_vpc
  vpc_cidr              = var.vpc_cidr
  vswitch_ids           = var.vswitch_ids
  vswitch_cidrs         = var.vswitch_cidrs
  worker_instance_types = var.worker_instance_types
  cluster_addons        = var.cluster_addons
  worker_disk_category  = var.worker_disk_category
  worker_disk_size      = var.worker_disk_size
  node_password         = var.node_password
  worker_number         = var.worker_number
  k8s_name_prefix       = var.k8s_name_prefix
  k8s_pod_cidr          = var.k8s_pod_cidr
  k8s_service_cidr      = var.k8s_service_cidr
  kube_config_path      = var.kube_config_path
  resource_group_id     = var.resource_group_id
  tags                  = var.tags
  // There should left enough scaling node quota when too many applicaiton need to be created。
  autoscaling_node_max_number = var.application_number + 10
  autoscaling_node_min_number = var.autoscaling_node_min_number
  autoscaling_node_bind_eip   = var.autoscaling_node_bind_eip
  apply_reserved_instance     = var.apply_reserved_instance
  reserved_instance_number    = var.reserved_instance_number
}

module "kubectl" {
  source           = "./kubectl"
  depends_on       = [module.kubernetes]
  kube_config_path = var.kube_config_path
}