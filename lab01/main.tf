provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_eip" "lb" {
  instance = aws_instance.test.id
  vpc      = true
}


resource "aws_instance" "test" {
  ami             = "ami-009c9406091cbd65a"
  instance_type   = "t2.micro"
  key_name        = "ssh-key"
  security_groups = ["ssh-access"]

}



resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
