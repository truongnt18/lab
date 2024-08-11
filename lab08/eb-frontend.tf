resource "aws_elastic_beanstalk_application" "web" {
  name        = "frontend-web-app"
  description = "Simple Web Application"
}

resource "aws_elastic_beanstalk_environment" "web" {
  name                = "frontend-web-env2"
  application         = aws_elastic_beanstalk_application.web.name
  tier                = "WebServer"
  solution_stack_name = var.solution_stack_name


  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = aws_vpc.web.id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = aws_subnet.private_subnet.id
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [aws_subnet.public_subnet.id, aws_subnet.private_subnet.id])
    resource  = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = "external"
    resource  = ""
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
    resource  = ""
  }

  setting {
    namespace = "aws:cloudformation:template:parameter"
    name      = "AppSource"
    value     = "https://simple-web-app-bucket-2024.s3.ap-southeast-1.amazonaws.com/web.zip"
    resource  = ""
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
    resource  = ""
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
    resource  = ""
  }


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_instance_profile.id
    resource  = ""
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    #value     = var.fe_instance_type
    value    = var.instance_type_ec2
    resource = ""
  }


  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_PORT"
    value     = "8000"
    resource  = ""
  }
  depends_on = [ 
    aws_s3_object.web_app_code,
    aws_nat_gateway.wordpress
  ]


  lifecycle {
    ignore_changes = [
      # Ignore Beanstalk Stack changed (Beanstalk upgrade version automatically)
      solution_stack_name,
      # Ignore Beanstalk option settings changed (Hostheader) and some app params updated via console
      setting
    ]
  }
}

output "eb_enviroment_url" {
  value = aws_elastic_beanstalk_environment.web.endpoint_url
}
