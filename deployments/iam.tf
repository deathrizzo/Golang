resource "aws_iam_role" "orbis-service" {
  name =  [ 
	"orbis-oam",
	"orbis-obm",
  ]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::595072229124:role/elzwhere"
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
