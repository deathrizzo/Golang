# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html

# https://www.terraform.io/docs/providers/aws/r/iam_role.html
resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = var.assume_role_policy

  path        = var.path
  description = var.description

}

# https://www.terraform.io/docs/providers/aws/r/iam_policy.html
resource "aws_iam_policy" "default" {
  name   = var.name
  policy = var.policy

  path        = var.path
  description = var.description
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
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