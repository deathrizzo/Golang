locals {
  environment         = "dev"
  application         = "site"
  team                = "me"
  customer            = "uniquely-flawed"
  data-classification = "restricted"

  common_tags = {
    Environment = "${local.environment}"
    Application = "${local.application}"
    Team        = "${local.team}"
    Customer    = "${local.customer}"
  }
}
