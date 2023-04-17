# Terraform module for K3s System Upgrade controller

This module installs the system-upgrade-controller. This allows for easier upgrading of the kubectl version and changing k3s channel.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1 |
| kubernetes | ~> 2 |
| local | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | ~> 2 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role_binding.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_deployment.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_manifest.system_upgrade](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account.upgrade_controller](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| k3s_channel | The channel to use for k3s upgrades. | `string` | `"stable"` | no |
| kubectl_version | The version of kubectl to use. | `string` | `"1.21.9"` | no |
| upgrade_controller_version | The version of the system-upgrade-controller to use. | `string` | `"v0.10.0"` | no |

## Outputs

No outputs.
