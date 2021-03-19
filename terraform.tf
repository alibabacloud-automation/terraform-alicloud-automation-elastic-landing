terraform {
  required_version = ">= 0.13"

  required_providers {
    alicloud = {
      source  = "hashicorp/alicloud"
      version = "~> 1.117.0"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "~> 1.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
  }
}