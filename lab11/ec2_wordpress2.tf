
resource "aws_eip" "ip2" {
  instance = aws_instance.wordpress_instance_2.id
  vpc      = true
}
resource "aws_instance" "wordpress_instance_2" {
  ami           = "ami-009c9406091cbd65a" 
  instance_type = var.instance_type_ec2
  key_name      = "ssh-key"
  vpc_security_group_ids = [aws_security_group.wordexpress_access.id]
  subnet_id       = aws_subnet.public_subnet.id
 
  tags = {
    Name = "WordPress Instance 2"
  }
 
  user_data = <<-EOF
              #!/bin/bash

              sudo yum update -y

              # create new database name wordpressdb2 for  WordPress Instance 2
              sudo yum install mariadb105 -y
              sudo mysql -u${aws_db_instance.wordpress_db.username} -p${aws_db_instance.wordpress_db.password} -h ${aws_db_instance.wordpress_db.address} -e "DROP DATABASE wordpressdb2; CREATE DATABASE IF NOT EXISTS wordpressdb2;"
              sudo mysql -u${aws_db_instance.wordpress_db.username} -p${aws_db_instance.wordpress_db.password} -h ${aws_db_instance.wordpress_db.address} -e "CREATE DATABASE IF NOT EXISTS wordpressdb2;"
              
              # install and configure for WordPress Instance 2
              sudo yum install -y httpd php php-mysqlnd
              cd /var/www/html
              sudo wget https://wordpress.org/latest.tar.gz
              sudo tar -xvzf latest.tar.gz
              sudo chown -R apache:apache wordpress
              cp wordpress/wp-config-sample.php wordpress/wp-config.php

              sudo sed -i 's/database_name_here/wordpressdb2/' wordpress/wp-config.php
              sudo sed -i 's/username_here/${aws_db_instance.wordpress_db.username}/' wordpress/wp-config.php
              sudo sed -i 's/password_here/${aws_db_instance.wordpress_db.password}/' wordpress/wp-config.php
              sudo sed -i 's/localhost/${aws_db_instance.wordpress_db.endpoint}/' wordpress/wp-config.php
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF
}
 
output "wordpress_public_ip2" {
   value = aws_eip.ip2.public_ip
}


 