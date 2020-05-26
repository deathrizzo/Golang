module "some_roles" {
  source             = "../modules/roles"
  name               = "complete"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  policy             = data.aws_iam_policy_document.policy.json

  path        = "/orbis/"
  description = "Define orbis servie roles"

}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

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

 resource "aws_iam_policy" "example" {
   # ... other configuration ...
   policy = <<POLICY
 {
   "Version": "2012-10-17",
   "Statement": {
     "Effect": "Allow",
     "Action": "*",
     "Resource": "*"
   }
 }
 POLICY
 }
