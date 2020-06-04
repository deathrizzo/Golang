locals {
  policies = { for v in var.iam_policy_arns : v => v }
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = var.role
  for_each   = local.policies
  policy_arn = each.key
}
