locals {
  k8s_name = substr(join("-", [var.k8s_name_prefix, var.environment, random_uuid.this.result]), 0, 63)
  name     = "for-${local.k8s_name}"
  tags = merge(
    {
      Created = "Terraform"
      Name    = local.k8s_name
      Env     = var.environment
    },
    var.tags,
  )
  vswitch_ids         = length(var.vswitch_ids) > 0 ? var.vswitch_ids : alicloud_vswitch.this.*.id
  zone_id             = length(var.availability_zones) > 0 ? var.availability_zones[0] : data.alicloud_zones.default.ids.0
  node_instance_types = length(var.worker_instance_types) > 0 ? var.worker_instance_types : data.alicloud_instance_types.default.ids
  quota_notice_type   = 0
}

resource "random_uuid" "this" {}