Alibaba Cloud Terraform Module
terraform-alicloud-automation-elastic-landing

The module aims to build an automation elastic landing which 
can be used to deploy k8s applications automatically. 
Also, it can auto scale kubernetes cluster nodes when the cluster 
nodes' CPU load exceeds the specified threshold.

![image](https://raw.githubusercontent.com/terraform-alicloud-modules/terraform-alicloud-automation-elastic-landing/main/architecture.png)

This module contains the following major contents:
1. Create a new VPC network environment for the kubernetes cluster, and the related resources include VPC, VSwitch, Security Group, Nat Gateway, Eip and so on;
2. Create a [managed kubernetes cluster](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cs_managed_kubernetes) and an auto-scaling [node pool](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cs_kubernetes_node_pool);
3. Run kubectl commands to install argocd and config [argocd provider](https://registry.terraform.io/providers/oboukili/argocd/latest/docs) by using [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) and [local-exec provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html) to ;
4. Deploy application successfully by using argocd resource [argocd_application](https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application).

In order to make the landing can run and auto-scale successfully, the module also supports more jobs:
1. Adds datasource to auto-open the related service, including Container Service, Log Service and Cloud Monitor Service;
2. Adds quota [alarm](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/quotas_quota_alarm) to send an alarm when kubernetes cluster dependent resourcs quota is below the threshold;
3. Adds quota [application](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/quotas_quota_application) to create apply for kubernetes cluster dependent resourcs quotas automatically when lacking quotas;
4. Supports to create [reserved instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/reserved_instance) to retain some resource types.

## Usage

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=terraform-alicloud-modules%3A%3Aautomation-elastic-landing&spm=docs.m.terraform-alicloud-modules.automation-elastic-landing&intl_lang=EN_US" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

```hcl
module "landing" {
  source  = "terraform-alicloud-modules/automation-elastic-landing/alicloud"
  region  = "ap-southeast-1"
  zone_ids = ["ap-southeast-1a"]
  application_url = "https://github.com/terraform-alicloud-modules/terraform-alicloud-automation-elastic-landing"
  application_path = "applications/appcenter/kustomize/base"
    
  tags = {
    App      = "appcenter"
    Environment = "dev"
  }
}
```

Running this module needs three steps:
1. Running `terraform apply` command will create kubernetes cluster and install argocd and config argocd provider;
2. Running `source .bash_profile` to make argocd provider setting affect;
3. Running `terraform apply` command again to deploy application.

## Notes
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  region = var.region
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "landing" {
  source           = "terraform-alicloud-modules/automation-elastic-landing/alicloud"
  version          = "1.0.0"
  region           = "ap-southeast-1"
  zone_ids         = ["ap-southeast-1a"]
  application_path = "applications/appcenter/kustomize/base"
  // ...
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region = "ap-southeast-1"
}
module "landing" {
  source           = "terraform-alicloud-modules/automation-elastic-landing/alicloud"
  zone_ids         = ["ap-southeast-1a"]
  application_path = "applications/appcenter/kustomize/base"
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region = "ap-southeast-1"
  alias  = "as"
}
module "landing" {
  source           = "terraform-alicloud-modules/automation-elastic-landing/alicloud"
  providers        = {
    alicloud = alicloud.as
  }
  zone_ids         = ["ap-southeast-1a"]
  application_path = "applications/appcenter/kustomize/base"
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.117.0 |

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)