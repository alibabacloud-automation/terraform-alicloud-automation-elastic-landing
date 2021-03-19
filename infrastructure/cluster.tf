resource "alicloud_cs_managed_kubernetes" "this" {
  cpu_policy               = "none"
  deletion_protection      = false
  exclude_autoscaler_nodes = false
  load_balancer_spec       = "slb.s1.small"
  name                     = local.k8s_name
  new_nat_gateway          = var.new_vpc == true ? false : true
  proxy_mode               = "ipvs"
  resource_group_id        = var.resource_group_id
  security_group_id        = concat(alicloud_security_group.this.*.id, [""])[0]
  worker_vswitch_ids       = local.vswitch_ids
  worker_disk_category     = var.worker_disk_category
  password                 = var.node_password
  pod_cidr                 = var.k8s_pod_cidr
  service_cidr             = var.k8s_service_cidr
  slb_internet_enabled     = true
  install_cloud_monitor    = true
  cluster_spec             = "ack.pro.small"
  worker_instance_types    = local.node_instance_types
  worker_number            = var.worker_number
  dynamic "addons" {
    for_each = var.cluster_addons
    content {
      name   = lookup(addons.value, "name", var.cluster_addons)
      config = lookup(addons.value, "config", var.cluster_addons)
    }
  }

  //maintenance_window {
  //enable = false
  //}

  kube_config = var.kube_config_path
  tags        = local.tags

  depends_on = [alicloud_snat_entry.this]
}

resource "alicloud_cs_kubernetes_node_pool" "autoscaling" {
  name                 = "autoscaling"
  cluster_id           = alicloud_cs_managed_kubernetes.this.id
  vswitch_ids          = [alicloud_vswitch.this[0].id]
  instance_types       = local.node_instance_types
  system_disk_category = "cloud_efficiency"
  system_disk_size     = 40
  //key_name                     = alicloud_key_pair.default.key_name
  password = var.node_password

  # automatic scaling node pool configuration.
  scaling_config {
    min_size                 = var.autoscaling_node_min_number
    max_size                 = var.autoscaling_node_max_number
    is_bond_eip              = var.autoscaling_node_bind_eip
    eip_internet_charge_type = "PayByTraffic"
    eip_bandwidth            = 5
  }
  tags = merge(
    {
      Type = "autoscaling"
    },
    local.tags,
  )
}