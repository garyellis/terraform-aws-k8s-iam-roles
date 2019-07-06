# tf_module_aws_iam_role_k8s

This terraform module creates kubernetes aws cloud provider iam configuration. It sets up the following resources:

* control plane iam permission policy, iam role and instance profile
* an optional list of user defined policies to attach to the control plane role
* worker iam permission policy, iam role and instance profile
* an optional list of user policies to attach to the worker role

## Terraform version

* v0.12


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | the name prefix of the iam resources | `string` | n/a | yes |
| count\_controlplane\_additional\_policy\_attachments | the count of arns in the `controlplane\_additional\_policy\_attachments` list | `number` | `0` | no |
| controlplane\_additional\_policy\_attachments | a list of iam policy arns attached to the controlplane iam role| `list(string)` | `[]` | no |
| worker\_additional\_policy\_attachments | a list of iam policy arns attached to the worker iam role| `list(string)` | `[]` | no |
| count\_worker\_additional\_policy\_attachments | the count of arns in the `worker\_additional\_policy\_attachments` list | `number` | `0` | no |
| route53\_zone\_ids | a list of route53 zone ids for External DNS controller to manage | `list(string)` | `["PLACEHOLDER"]` | no |
| tags | a map of tags to create on taggable resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Type |
|------|-------------|:------:|
| controlplane |  the control plane iam instance profile resource | `object` |
| worker | the worker iam instance profile role resource  | `object` |
