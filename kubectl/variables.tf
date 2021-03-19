variable "kube_config_path" {
  description = "The path of kube config, like ~/.kube/config"
  type        = string
  default     = ".kubeconfig"
}

variable "argocd_provider_config" {
  description = "The path of setting argocd provider config, like .bash_profile"
  type        = string
  default     = ".bash_profile"
}