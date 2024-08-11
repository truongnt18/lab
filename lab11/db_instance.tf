provider "aws" {
  region = var.region
}
 
resource "aws_db_instance" "wordpress_db" {
  identifier           = "wordpress-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.instance_type_db
  db_name              = "wordpressdb"
  username             = "admin"
  password             = "admin123"
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  parameter_group_name = "default.mysql5.7"
  multi_az             = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db.id]
 
}

# DB subnet group for host DB WordPress
resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-db-subnet"
  subnet_ids = [aws_subnet.private_subnet.id,aws_subnet.public_subnet.id]
}

# -------------------------------------------------------------------------------- #
# Security Group For DB
# -------------------------------------------------------------------------------- #
resource "aws_security_group" "db" {
  name        = "database-sg"
  vpc_id      = aws_vpc.wordpress.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["10.0.0.0/16"]

    description     = "Allow wordpress instasnce access to db"
  }


}

