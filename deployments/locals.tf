locals {
  environment         = "dev"
  application         = "orbis"
  team                = "dtc"
  customer            = "iStreamPlanet"
  data-classification = "restricted"

  common_tags = {
    Environment = "${local.environment}"
    Application = "${local.application}"
    Team        = "${local.team}"
    Customer    = "${local.customer}"
  }
}
