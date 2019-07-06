module "iam_roles" {
  source = "../"

  name = "tf-k8s-iam-roles"
}

output "controlplane_arn" {
  value = module.iam_roles.controlplane
}

output "worker_arn" {
  value = module.iam_roles.worker
}
