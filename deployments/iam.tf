data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::595072229124:role/elzwhere"]
    }
  }
}

resource "aws_iam_role" "orbis-oam" {
  name               = "orbis-oam"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_role" "orbis-obm" {
  name               = "orbis-obm"
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}

resource "aws_iam_role" "example" {
  count              = length(var.user_names)
  name               = var.user_names[count.index]
  assume_role_policy = "${data.aws_iam_policy_document.instance-assume-role-policy.json}"
}