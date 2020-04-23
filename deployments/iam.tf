resource "aws_iam_policy" "orbis-service" {

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement" {
      "Effect": "Allow",
      "Principal": "AWS": "arn:aws:iam::595072229124:role/elzwhere",
      "Action": "sts:AssumeRole"
  }
}
POLICY
}

resource "aws_iam_role" "orbis-oam" {
  name               = "orbis-oam"
  assume_role_policy = "aws_iam_policy.orbis.service.json"
}


