data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions       = ["sts:AssumeRole"]
    effect        = "Allow"
    principals    {
        type        = "Service"
        identifiers = ["ec2.amazonaws.com"]
      }
  }
}

# controlplane iam configuration
data "aws_iam_policy_document" "controlplane" {
  statement {
    sid       = "StorageClassEBS"
    effect    = "Allow"
    actions   = [
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeVolumes",
      "ec2:CreateTags",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "ServiceELB"
    effect    = "Allow"
    actions   = [
      "elasticloadbalancing:*",
      "ec2:DescribeRegions",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupReferences",
      "ec2:DescribeStaleSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:DescribeRouteTables",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "controlplane" {
  name_prefix   = format("%s-controlplane", var.name)
  policy        = data.aws_iam_policy_document.controlplane.json
}

locals {
  controlplane_policy_arns = compact(concat(var.controlplane_additional_policy_attachments, aws_iam_policy.controlplane.*.arn))
}

resource "aws_iam_role" "controlplane" {
  name_prefix        = format("%s-controlplane", var.name)
  description        = "kubernetes cloud provider controlplane"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = merge(map("Name", format("%s-controlplane", var.name)), var.tags)
}

resource "aws_iam_instance_profile" "controlplane" {
  name_prefix = format("%s-controlplane", var.name)
  role        = aws_iam_role.controlplane.name
}

resource "aws_iam_role_policy_attachment" "controlplane_policy_attachments" {
  count = var.count_controlplane_additional_policy_attachments + 1
  role       = aws_iam_role.controlplane.name
  policy_arn = local.controlplane_policy_arns[count.index]
}


# worker iam configuration
data "aws_iam_policy_document" "worker" {
  statement {
    sid       = "AWSCloudProviderWorkerMinimum"
    actions   = [
      "ec2:DescribeInstances",
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid       = "ExternalDNSControllerWrite"
    effect    = "Allow"
    actions   = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      for i in var.route53_zone_ids:
        format("arn:aws:route53:::hostedzone/%s", i)
    ]
  }

  statement {
   sid        = "ExternalDNSControllerRead"
   effect     = "Allow"
   actions    = [
     "route53:ListHostedZones",
     "route53:ListResourceRecordSets"
   ]
   resources = ["*"]
  }
}

resource "aws_iam_policy" "worker" {
  name_prefix   = format("%s-worker", var.name)
  policy        = data.aws_iam_policy_document.worker.json
}

resource "aws_iam_role" "worker" {
  name_prefix        = format("%s-worker", var.name)
  description        = "kubernetes cloud provider worker"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = merge(map("Name", format("%s-worker", var.name)), var.tags)
}

resource "aws_iam_instance_profile" "worker" {
  name_prefix = format("%s-worker", var.name)
  role        = aws_iam_role.worker.name
}

locals {
  worker_policy_arns = compact(concat(var.worker_additional_policy_attachments, aws_iam_policy.worker.*.arn))
}

resource "aws_iam_role_policy_attachment" "worker_policy_attachments" {
  count = var.count_worker_additional_policy_attachments + 1
  role       = aws_iam_role.worker.name
  policy_arn = local.worker_policy_arns[count.index]
}
