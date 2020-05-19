data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = var.service_ids
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "orbis_roles" {
  count              = length(var.service_names)
  name               = var.service_names[count.index]
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  path               = var.path
  tags               = var.tags
}

resource "aws_iam_policy_attachment" "policies" {
  count      = length(var.policy_arns)
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.orbis_roles.name
}
