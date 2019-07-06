module "iam_roles" {
  source = "../"

  name               = "tf-k8s-iam-roles"
  #external_dns_zones = ["ZOXXXXX", "Z3XXXXXX"]
}

output "controlplane" {
  value = module.iam_roles.controlplane
}

output "worker" {
  value = module.iam_roles.worker
}
