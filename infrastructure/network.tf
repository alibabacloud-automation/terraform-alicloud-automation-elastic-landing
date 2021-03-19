// Instance_types data source for instance_type
data "alicloud_instance_types" "default" {
  kubernetes_node_role = "Worker"
  cpu_core_count       = var.cpu_core_count
  memory_size          = var.memory_size
}

// Zones data source for availability_zone
data "alicloud_zones" "default" {
  available_instance_type = data.alicloud_instance_types.default.ids[0]
}

// If there is not specifying vpc_id, the module will launch a new vpc
resource "alicloud_vpc" "this" {
  count             = var.new_vpc == true ? 1 : 0
  cidr_block        = var.vpc_cidr
  name              = local.name
  tags              = local.tags
  resource_group_id = var.resource_group_id
}

// According to the vswitch cidr blocks to launch several vswitches
resource "alicloud_vswitch" "this" {
  count             = var.new_vpc == true ? length(var.vswitch_cidrs) : 0
  vpc_id            = concat(alicloud_vpc.this.*.id, [""])[0]
  cidr_block        = var.vswitch_cidrs[count.index]
  availability_zone = local.zone_id
  name              = local.name
  tags              = local.tags
}

resource "alicloud_security_group" "this" {
  count             = var.new_vpc == true ? 1 : 0
  vpc_id            = alicloud_vpc.this[0].id
  name              = local.name
  resource_group_id = var.resource_group_id
  description       = "security group of ACS Cluster ${local.k8s_name}"
}
resource "alicloud_security_group_rule" "icmp" {
  count             = var.new_vpc == true ? 1 : 0
  security_group_id = alicloud_security_group.this[0].id
  type              = "ingress"
  ip_protocol       = "icmp"
  port_range        = "-1/-1"
  nic_type          = "intranet"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
  priority          = 100
}
resource "alicloud_security_group_rule" "all" {
  count             = var.new_vpc == true ? 1 : 0
  security_group_id = alicloud_security_group.this[0].id
  type              = "ingress"
  ip_protocol       = "all"
  port_range        = "-1/-1"
  nic_type          = "intranet"
  cidr_ip           = var.k8s_pod_cidr
  policy            = "accept"
  priority          = 100
}
resource "alicloud_nat_gateway" "this" {
  count         = var.new_vpc == true ? 1 : 0
  vpc_id        = concat(alicloud_vpc.this.*.id, [""])[0]
  name          = local.name
  specification = "Small"
  nat_type      = "Enhanced"
  vswitch_id    = concat(alicloud_vswitch.this.*.id, [""])[0]

  //    tags   = local.tags
}

resource "alicloud_eip" "this" {
  count     = var.new_vpc == true ? 1 : 0
  bandwidth = 10
  name      = local.name
  tags      = local.tags
}

resource "alicloud_eip_association" "this" {
  count         = var.new_vpc == true ? 1 : 0
  allocation_id = concat(alicloud_eip.this.*.id, [""])[0]
  instance_id   = concat(alicloud_nat_gateway.this.*.id, [""])[0]
}

resource "alicloud_snat_entry" "this" {
  count             = var.new_vpc == true ? length(var.vswitch_cidrs) : 0
  snat_table_id     = concat(alicloud_nat_gateway.this.*.snat_table_ids, [""])[0]
  source_vswitch_id = alicloud_vswitch.this[count.index].id
  snat_ip           = concat(alicloud_eip.this.*.ip_address, [""])[0]
}