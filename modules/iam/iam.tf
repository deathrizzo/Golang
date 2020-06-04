data "aws_iam_policy_document" "assume-role-policy-oidc" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "AWS"

      identifiers = var.iam_providers
    }
  }
}

resource "aws_iam_role" "orbis_roles" {
  count              = length(var.service_names)
  name               = var.service_names[count.index]
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-oidc.json
  path               = var.path
  tags               = var.tags
}

locals{
    policies = { for v in var.iam_policy_arns : v => v }
}



resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role = "oam"
  for_each = local.policies
  policy_arn  = each.key
}
/*
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role = "oam"
  count = "${length(var.iam_policy_arns)}"
  policy_arn = var.iam_policy_arns[count.index]
}
*/


/*
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role = "oam"
  count = "${length(var.iam_policy_arns)}"
  policy_arn = var.iam_policy_arns[count.index]
}
*/
/*
resource "aws_iam_role" "sumdumbshit" {
  for_each = "${var.service_names}"
  name = "${var.service_names[each.key]}"
  assume_role_policy = data.aws_iam_policy_document.assume-role-policy-oidc.json
}

*/
/*
resource "aws_iam_user_policy_attachment" "policies" {
  for_each = {
    for up in var.policy_arn :
    "${up.name} ${up.iam_policy_arns}" => up

  name       = each.value.name
  policy_arn = each.value.iam_policy_arns
}

*/


/*
resource "aws_iam_policy_attachment" "policies" {
  for_each   = toset(var.service_names)
  name       = each.value
  policy_arn = var.iam_policy_arns
  roles      = each.value
}
*/
/*

resource "aws_iam_policy_attachment" "policies" {
  count      = length(var.service_names)
  name       = var.service_names[count.index]
  policy_arn = "${element(var.iam_policy_arns, count.index)}"
  for_each   = var.service_names
  roles      = "each.value"
}
*/

/*
resource "aws_iam_policy_attachment" "policies" {
  name       = "something"
  policy_arn = var.iam_policy_arns
  for_each = toset(var.service_names)
  roles      = each.value
}
*/