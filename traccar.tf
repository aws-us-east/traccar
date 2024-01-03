provider "aws" {
  profile    = "us.east.1"
  region     = "us-east-1"
}

resource "aws_elastic_beanstalk_application" "traccar" {
  name        = "traccar-tf"
}

resource "aws_elastic_beanstalk_environment" "traccar-env" {
  source = "."
  name                = "traccar-env"
  application         = aws_elastic_beanstalk_application.traccar.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.1.2 running Corretto 11"
  setting {
        namespace = "aws:autoscaling:launchconfiguration"
        name = "IamInstanceProfile"
        value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t3.small"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "LoadBalancerType"
    value = "application"
  }
  setting {
    namespace = "aws:elbv2:listener:443"
    name = "Protocol"
    value = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name = "ListenerEnabled"
    value = "true"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name = "SSLCertificateArns"
    value = var.loadbalancer_certificate_arn
  }
}
