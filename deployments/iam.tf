variable "service_names" {
  description = "Create Iam roles with these names"
  default     = ["neo", "trinity", "morpheus"]
}

data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::595072229124:role/elzwhere"]
    }
  }
}

resource "aws_iam_role" "example" {
  count              = length(var.service_names)
  name               = var.service_names[count.index]
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  path               = "/orbis/"
}