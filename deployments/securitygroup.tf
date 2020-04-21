resource "aws_security_group" "flaming_elk_sg" {
  name = "flaming_elk_sg"
  description = "Open ports for logstash,kibana,ssh"
  vpc_id = "vpc-19c73e7c"

  ingress {
        from_port = 5601
        to_port = 5601
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = "20"
    to_port     = "20"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "flaming_elk_sg"
  }
}
