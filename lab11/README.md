

Run following step:
  1.  Create VPC, subnet, Internet Gateway, Nat Gateway, RDS mysql, EC2 wordpress1 instance, EC2 wordpress3 instance:
       - terraform init
       - terraform plan
       - terraform apply
  2.  Output wordpress_public_ip1 and wordpress_public_ip2
  3.  Access to website of wordpress1: http://wordpress_public_ip1/wordpress
  4.  Access to website of wordpress2: http://wordpress_public_ip2/wordpress
     
   