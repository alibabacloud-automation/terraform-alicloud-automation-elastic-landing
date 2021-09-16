Alibaba Cloud Terraform Module
terraform-alicloud-automation-elastic-landing
=====================================================================

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

## Terraform versions

This module requires Terraform 0.13.

## Usage

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

## Notes

Running this module needs three steps:
1. Running `terraform apply` command will create kubernetes cluster and install argocd and config argocd provider;
2. Running `source .bash_profile` to make argocd provider setting affect;
3. Running `terraform apply` command again to deploy application.

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