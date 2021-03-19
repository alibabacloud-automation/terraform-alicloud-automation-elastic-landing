resource "alicloud_reserved_instance" "default" {
  count           = var.apply_reserved_instance == true ? var.reserved_instance_number : 0
  instance_type   = local.node_instance_types[0]
  instance_amount = 1
  period_unit     = "Year"
  offering_type   = "All Upfront"
  name            = local.name
  description     = "Reserved Instance used to autoscaling kubernetes node pool"
  zone_id         = local.zone_id
  scope           = "Zone"
  period          = 1
}