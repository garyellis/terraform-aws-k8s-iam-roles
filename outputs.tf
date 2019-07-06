output "controlplane" {
  value = aws_iam_role.controlplane
}

output "worker" {
  value = aws_iam_role.worker
}
