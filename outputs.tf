output "controlplane" {
  value = aws_iam_instance_profile.controlplane
}

output "worker" {
  value = aws_iam_instance_profile.worker
}
