resource "aws_iam_role" "orbis-oam" {
  name = "orbis-oam"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "arn:aws:iam::595072229124:role/elzwhere"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    orbis-service = "oam"
  }
}
