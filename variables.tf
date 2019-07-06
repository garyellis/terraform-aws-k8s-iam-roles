variable "name" {
  description = "a common name for the iam permission policy resources. This should be the cluster name"
  type = string
}

variable "controlplane_additional_policy_attachments" {
  description = "Attach additional policies to the controlplane iam role. Up to 7 policies are allowed"
  type = list(string)
  default = []
}

variable "count_controlplane_additional_policy_attachments" {
  description = "The number of additional control plane attachments"
  type = number
  default = 0
}

variable "worker_additional_policy_attachments" {
  description = "Attach additional policies to the worker iam role. Up to 7 policies are allowe"
  type = list(string)
  default = []
}

variable "count_worker_additional_policy_attachments" {
  description = "The number of additional control plane attachments"
  type = number
  default = 0
}

variable "tags" {
  description = "A map of tags to create on taggable resources"
  type = map(string)
  default = {}
}
