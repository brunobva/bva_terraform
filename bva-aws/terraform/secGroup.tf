resource "aws_security_group" "bvaMainRules" {
  name   = "bva-sg-main-rules"
  vpc_id = aws_vpc.bvaVpc.id

  ingress {
    description = "BVA SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bvaIP]
  }

  ingress {
    description = "BVA HTTPS access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.bvaIP]
  }

  ingress {
    description = "BVA HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.bvaIP]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BVA | Security group"
  }
}