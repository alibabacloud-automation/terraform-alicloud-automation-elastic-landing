resource "alicloud_ram_policy" "for-k8s-nodepools" {
  policy_name     = "k8s-nodepools-access-ess-to-scaling"
  policy_document = <<EOF
		{
		  "Statement": [
			{
			  "Action": [
                "ess:Describe*",
                "ess:CreateScalingRule",
                "ess:ModifyScalingGroup",
                "ess:RemoveInstances",
                "ess:ExecuteScalingRule",
                "ess:ModifyScalingRule",
                "ess:DeleteScalingRule",
                "ecs:DescribeInstanceTypes",
                "ess:DetachInstances",
                "vpc:DescribeVSwitches"
			  ],
			  "Effect": "Allow",
			  "Resource": [
				"*"
			  ]
			}
		  ],
			"Version": "1"
		}
	  EOF
  description     = "Ram policy used to auto scaling nodepools"
  force           = true
}


resource "alicloud_ram_role_policy_attachment" "attaching-k8s-role" {
  policy_name = alicloud_ram_policy.for-k8s-nodepools.policy_name
  policy_type = "Custom"
  role_name   = alicloud_cs_managed_kubernetes.this.worker_ram_role_name
}

data "alicloud_ram_roles" "AliyunCSManagedAutoScalerRole" {
  name_regex = "AliyunCSManagedAutoScalerRole"
}
resource "alicloud_ram_role" "AliyunCSManagedAutoScalerRole" {
  count       = length(data.alicloud_ram_roles.AliyunCSManagedAutoScalerRole.ids) > 0 ? 0 : 1
  name        = "AliyunCSManagedAutoScalerRole"
  document    = <<EOF
      {
        "Statement": [
          {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Principal": {
              "Service": [
                "cs.aliyuncs.com"
              ]
            }
          }
        ],
        "Version": "1"
      }
EOF
  description = "CS使用此角色来访问您在其他云产品中的资源。"
}

resource "alicloud_ram_role_policy_attachment" "AliyunCSManagedAutoScalerRole" {
  count       = length(data.alicloud_ram_roles.AliyunCSManagedAutoScalerRole.ids) > 0 ? 0 : 1
  role_name   = concat(alicloud_ram_role.AliyunCSManagedAutoScalerRole.*.name, [""])[0]
  policy_name = "AliyunCSManagedAutoScalerRolePolicy"
  policy_type = "System"
}