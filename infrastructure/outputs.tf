// Output kubernetes resource
output "this_k8s_name" {
  description = "Name of the kunernetes cluster."
  value       = alicloud_cs_managed_kubernetes.this.name
}
output "this_k8s_id" {
  description = "ID of the kunernetes cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.id, [""])[0]
}
output "this_k8s_nodes" {
  description = "List nodes of cluster."
  value       = concat(alicloud_cs_managed_kubernetes.this.*.worker_nodes, [""])[0]
}
output "this_k8s_node_ids" {
  description = "List ids of of cluster node."
  value       = [for _, obj in concat(alicloud_cs_managed_kubernetes.this.*.worker_nodes, [{}])[0] : lookup(obj, "id")]
}
output "this_k8s_scalinggroup_id" {
  description = "The scaling group id of the kubernetes auto scaling node pool."
  value       = alicloud_cs_kubernetes_node_pool.autoscaling.scaling_group_id
}
// Output VPC
output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = alicloud_cs_managed_kubernetes.this.vpc_id
}

output "this_vswitch_ids" {
  description = "List ID of the VSwitches."
  value       = local.vswitch_ids
}
output "this_security_group_id" {
  description = "ID of the Security Group used to deploy kubernetes cluster."
  value       = alicloud_cs_managed_kubernetes.this.security_group_id
}