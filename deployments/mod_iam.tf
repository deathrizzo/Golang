module "service_roles" {
  source        = "../modules/iam"
  service_names = ["dude", "this", "sucks"]
  service_ids   = ["arn:aws:iam::595072229124:role/elzwhere"]
  path          = "/orbis/"
  description   = "service roles"
  policy_arns   = ["arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
  tags = {
    Environment = "dev"
    Customer    = "dtc"
    Team        = "dtc"
  }
}
