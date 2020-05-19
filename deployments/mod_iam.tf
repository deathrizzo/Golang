module "service_roles" {
  source        = "../modules/iam"
  service_names = ["dude", "this", "sucks"]
  service_ids   = ["arn:aws:iam::595072229124:role/elzwhere"]
  path          = "/orbis/"
  description   = "service roles"
  tags = {
    Environment = "dev"
    Customer    = "dtc"
  }
}
