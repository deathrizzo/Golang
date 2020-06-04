module "policy-attachment" {
  source          = "../modules/policy-attachment"
  role            = "oam"
  iam_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}