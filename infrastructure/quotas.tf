# Kubernetes Cluster 的节点（quota code：q_i5uzm3）依赖如下资源的 Quota：
# eip: q_6aroz 用户可保有的EIP数量
# slb: q_fh20b0 每个slb实例后端可以挂载的服务器数量
# slb: q_2xnnv6 每个实例可以保有的监听数量
# slb: q_3mmbsp 用户可保有的slb实例个数
# ecs: q_elastic-network-interfaces 当前账户可拥有的弹性网卡（辅助网卡）创建的最大数量 (含 "Dimensions": regionId)
# ecs-spec: ecs-spec
#

data "alicloud_quotas_quotas" "eip" {
  product_code      = "eip"
  quota_action_code = "q_6aroz"
}

resource "alicloud_quotas_quota_application" "eip" {
  count             = length(data.alicloud_quotas_quotas.eip.quotas) > 0 ? data.alicloud_quotas_quotas.eip.quotas.0.total_usage > (data.alicloud_quotas_quotas.eip.quotas.0.total_quota / 2) ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.eip.quotas.0.total_quota
  product_code      = "eip"
  quota_action_code = "q_6aroz"
  reason            = "Used to auto scaling kubernetes node pools"
}
resource "alicloud_quotas_quota_alarm" "eip" {
  count             = length(data.alicloud_quotas_quotas.eip.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "eip-for-kubernetes"
  product_code      = "eip"
  quota_action_code = "q_6aroz"
  threshold         = data.alicloud_quotas_quotas.eip.quotas.0.total_quota / 2
}

data "alicloud_quotas_quotas" "slb-attaching-ecs" {
  product_code      = "slb"
  quota_action_code = "q_fh20b0"
}
resource "alicloud_quotas_quota_application" "slb-attaching-ecs" {
  count             = length(data.alicloud_quotas_quotas.slb-attaching-ecs.quotas) > 0 ? data.alicloud_quotas_quotas.slb-attaching-ecs.quotas.0.total_usage > data.alicloud_quotas_quotas.slb-attaching-ecs.quotas.0.total_quota / 2 ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.slb-attaching-ecs.quotas.0.total_quota
  product_code      = "slb"
  quota_action_code = "q_fh20b0"
  reason            = "Used to auto scaling kubernetes node pools"
}
resource "alicloud_quotas_quota_alarm" "slb-attaching-ecs" {
  count             = length(data.alicloud_quotas_quotas.slb-attaching-ecs.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "slb-attaching-ecs-for-kubernetes"
  product_code      = "slb"
  quota_action_code = "q_fh20b0"
  threshold         = data.alicloud_quotas_quotas.slb-attaching-ecs.quotas.0.total_quota / 2
}

data "alicloud_quotas_quotas" "slb-attaching-listener" {
  product_code      = "slb"
  quota_action_code = "q_2xnnv6"
}
resource "alicloud_quotas_quota_application" "slb-attaching-listener" {
  count             = length(data.alicloud_quotas_quotas.slb-attaching-listener.quotas) > 0 ? data.alicloud_quotas_quotas.slb-attaching-listener.quotas.0.total_usage > data.alicloud_quotas_quotas.slb-attaching-listener.quotas.0.total_quota / 2 ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.slb-attaching-listener.quotas.0.total_quota
  product_code      = "slb"
  quota_action_code = "q_2xnnv6"
  reason            = "Used to auto scaling kubernetes node pools"
}
resource "alicloud_quotas_quota_alarm" "slb-attaching-listener" {
  count             = length(data.alicloud_quotas_quotas.slb-attaching-listener.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "slb-attaching-listener-for-kubernetes"
  product_code      = "slb"
  quota_action_code = "q_2xnnv6"
  threshold         = data.alicloud_quotas_quotas.slb-attaching-listener.quotas.0.total_quota / 2
}

data "alicloud_quotas_quotas" "slb-instances" {
  product_code      = "slb"
  quota_action_code = "q_3mmbsp"
}
resource "alicloud_quotas_quota_application" "slb-instances" {
  count             = length(data.alicloud_quotas_quotas.slb-instances.quotas) > 0 ? data.alicloud_quotas_quotas.slb-instances.quotas.0.total_usage > data.alicloud_quotas_quotas.slb-instances.quotas.0.total_quota / 2 ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.slb-instances.quotas.0.total_quota
  product_code      = "slb"
  quota_action_code = "q_3mmbsp"
  reason            = "Used to auto scaling kubernetes node pools"
}
resource "alicloud_quotas_quota_alarm" "slb-instances" {
  count             = length(data.alicloud_quotas_quotas.slb-instances.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "slb-instances-for-kubernetes"
  product_code      = "slb"
  quota_action_code = "q_3mmbsp"
  threshold         = data.alicloud_quotas_quotas.slb-instances.quotas.0.total_quota / 2
}

data "alicloud_quotas_quotas" "eci" {
  product_code      = "ecs"
  quota_action_code = "q_elastic-network-interfaces"
  dimensions {
    key   = "regionId"
    value = var.region
  }
}
resource "alicloud_quotas_quota_application" "eci" {
  count             = length(data.alicloud_quotas_quotas.eci.quotas) > 0 ? data.alicloud_quotas_quotas.eci.quotas.0.total_usage > data.alicloud_quotas_quotas.eci.quotas.0.total_quota / 2 ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.eci.quotas.0.total_quota
  product_code      = "ecs"
  quota_action_code = "q_elastic-network-interfaces"
  reason            = "Used to auto scaling kubernetes node pools"
  dimensions {
    key   = "regionId"
    value = var.region
  }
}
resource "alicloud_quotas_quota_alarm" "eci" {
  count             = length(data.alicloud_quotas_quotas.eci.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "eci-for-kubernetes"
  product_code      = "ecs"
  quota_action_code = "q_elastic-network-interfaces"
  threshold         = data.alicloud_quotas_quotas.eci.quotas.0.total_quota / 2
  quota_dimensions {
    key   = "regionId"
    value = var.region
  }
}

data "alicloud_quotas_quotas" "ecs-instance-type" {
  product_code      = "ecs-spec"
  quota_action_code = local.node_instance_types[0]
  dimensions {
    key   = "regionId"
    value = var.region
  }
  dimensions {
    key   = "zoneId"
    value = local.zone_id
  }
  dimensions {
    key   = "chargeType"
    value = "PostPaid"
  }
  dimensions {
    key   = "networkType"
    value = "vpc"
  }
  dimensions {
    key   = "resourceType"
    value = "InstanceType"
  }
}
resource "alicloud_quotas_quota_application" "ecs-instance-type" {
  count             = length(data.alicloud_quotas_quotas.ecs-instance-type.quotas) > 0 ? data.alicloud_quotas_quotas.ecs-instance-type.quotas.0.total_usage > data.alicloud_quotas_quotas.ecs-instance-type.quotas.0.total_quota / 2 ? 1 : 0 : 0
  notice_type       = local.quota_notice_type
  desire_value      = 2 * data.alicloud_quotas_quotas.ecs-instance-type.quotas.0.total_quota
  product_code      = "ecs-spec"
  quota_action_code = local.node_instance_types[0]
  reason            = "Used to auto scaling kubernetes node pools"
  dimensions {
    key   = "regionId"
    value = var.region
  }
  dimensions {
    key   = "zoneId"
    value = local.zone_id
  }
  dimensions {
    key   = "chargeType"
    value = "PostPaid"
  }
  dimensions {
    key   = "networkType"
    value = "vpc"
  }
  dimensions {
    key   = "resourceType"
    value = "InstanceType"
  }
}
resource "alicloud_quotas_quota_alarm" "ecs-instance-type" {
  count             = length(data.alicloud_quotas_quotas.ecs-instance-type.quotas) > 0 ? 1 : 0
  quota_alarm_name  = "ecs-instance-type-for-kubernetes"
  product_code      = "ecs-spec"
  quota_action_code = local.node_instance_types[0]
  threshold         = data.alicloud_quotas_quotas.ecs-instance-type.quotas.0.total_quota / 2
  quota_dimensions {
    key   = "regionId"
    value = var.region
  }
  quota_dimensions {
    key   = "zoneId"
    value = local.zone_id
  }
  quota_dimensions {
    key   = "chargeType"
    value = "PostPaid"
  }
  quota_dimensions {
    key   = "networkType"
    value = "vpc"
  }
  quota_dimensions {
    key   = "resourceType"
    value = "InstanceType"
  }
}

