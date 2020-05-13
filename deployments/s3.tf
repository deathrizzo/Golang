resource "aws_s3_bucket" "example-dtc-bucket" {
  bucket = "example-dtc-bucket"
  acl    = "private"

  tags = {
    Environment = "${local.environment}"
    Application = "${local.application}"
    Team        = "${local.team}"
    Customer    = "${local.customer}"

  }
}
