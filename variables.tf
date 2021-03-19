variable "region" {
  description = "The region id in which kubernetes cluster. Recommand the international region because of needing loading application template from github."
  type        = string
  default     = "ap-southeast-1"
}
variable "zone_ids" {
  description = "List available zone ids used to create several new vswitches and kubernetes cluster."
  type        = list(string)
  default     = ["ap-southeast-1a"]
}
variable "environment" {
  description = "The kubernetes cluster environment label, like daily, pre, prod and so on."
  type        = string
  default     = "prod"
}
variable "enable_service" {
  description = "Whether to enable the releated service automatically, including ACK, SLS and CMS."
  type        = string
  default     = "Off"
}
# VPC variables
variable "new_vpc" {
  description = "Create a new vpc for this module."
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "The cidr block used to launch a new vpc."
  type        = string
  default     = "10.1.0.0/21"
}

# VSwitch variables
variable "vswitch_ids" {
  description = "List Ids of existing vswitch."
  type        = list(string)
  default     = []
}

variable "vswitch_cidrs" {
  description = "List cidr blocks used to create several new vswitches when 'new_vpc' is true."
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

# Cluster nodes variables
variable "worker_instance_types" {
  description = "The ecs instance type used to launch worker nodes. If not set, data source `alicloud_instance_types` will return one based on `cpu_core_count` and `memory_size`."
  type        = list(string)
  default     = ["ecs.sn1ne.large", "ecs.sn1ne.xlarge", "ecs.c6.xlarge"]
}

variable "cluster_addons" {
  description = "Addon components in kubernetes cluster"
  type = list(object({
    name   = string
    config = string
  }))
  default = []
}

variable "worker_disk_category" {
  description = "The system disk category used to launch one or more worker nodes."
  type        = string
  default     = "cloud_efficiency"
}

variable "worker_disk_size" {
  description = "The system disk size used to launch one or more worker nodes."
  type        = number
  default     = 40
}

variable "node_password" {
  description = "The password of worker nodes."
  type        = string
  default     = "YourPassword123"
}

variable "worker_number" {
  description = "The number of kubernetes cluster work nodes. The value does not contain the auto-scaled nodes."
  type        = number
  default     = 1
}

variable "k8s_name_prefix" {
  description = "The name prefix used to create managed kubernetes cluster."
  type        = string
  default     = "terraform-alicloud-managed-kubernetes"
}

variable "k8s_pod_cidr" {
  description = "The kubernetes pod cidr block. It cannot be equals to vpc's or vswitch's and cannot be in them. If vpc's cidr block is `172.16.XX.XX/XX`, it had better to `192.168.XX.XX/XX` or `10.XX.XX.XX/XX`."
  type        = string
  default     = "172.20.0.0/16"
}

variable "k8s_service_cidr" {
  description = "The kubernetes service cidr block. It cannot be equals to vpc's or vswitch's or pod's and cannot be in them. Its setting rule is same as `k8s_pod_cidr`."
  type        = string
  default     = "172.21.0.0/20"
}

variable "kube_config_path" {
  description = "The path of kube config, like ~/.kube/config"
  type        = string
  default     = ".kubeconfig"
}

variable "resource_group_id" {
  description = "The resource group id."
  type        = string
  default     = "rg-acfmwvvtg5owavy"
}
variable "tags" {
  description = "The resource tags"
  type        = map(string)
  default     = {}
}
variable "autoscaling_node_min_number" {
  description = "The minimize number of autoscaling nodes. Default to 0"
  type        = number
  default     = 0
}
variable "autoscaling_node_max_number" {
  description = "The maximize number of autoscaling nodes. Default to 10"
  type        = number
  default     = 10
}
variable "autoscaling_node_bind_eip" {
  description = "Whether bind an eip address to auto scaling node"
  type        = bool
  default     = false
}

variable "apply_reserved_instance" {
  description = "Whether apply reserved instance to avoid the lack of resource quota"
  type        = bool
  default     = false
}

variable "reserved_instance_number" {
  description = "The number of reserved instance. It is valid when `apply_reserved_instance` is true."
  type        = number
  default     = 1
}

variable "application_number" {
  description = "The number of the application."
  type        = number
  default     = 1
}
variable "application_url" {
  description = "The url of the application."
  type        = string
  default     = "https://github.com/terraform-alicloud-modules/terraform-alicloud-automation-elastic-landing"
}
variable "application_path" {
  description = "The application deployment template directory in the application project."
  type        = string
  default     = "applications/appcenter/kustomize/base"
}
variable "application_target_revision" {
  description = "Defines the commit, tag, or branch in which to sync the application to."
  type        = string
  default     = "main"
}