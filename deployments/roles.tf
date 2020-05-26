module "service_roles" {
  source             = "../modules/roles"
  name               = "complete"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  policy             = data.aws_iam_policy_document.policy.json

  path        = "/orbis/"
  description = "Define orbis servie roles"

}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    Effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::595072229124:role/elzwhere"]
    }

    actions = [
      "sts:AssumeRole",
    ]
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:Describe*",
    ]

    resources = ["*"]
  }
}