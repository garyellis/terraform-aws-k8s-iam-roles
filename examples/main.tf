module "iam_roles" {
  source = "../"

  name = "tf-k8s-iam-roles"
}

output "controlplane" {
  value = module.iam_roles.controlplane
}

output "worker" {
  value = module.iam_roles.worker
}
