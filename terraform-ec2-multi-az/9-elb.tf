# https://stackoverflow.com/questions/69102518/ec2-instance-i-is-not-in-the-same-vpc-as-elb-using-terraform
# in Route53 or any other DNS server config... the ELB name is added as CNAME, A for IP Addresses

# Create a new load balancer
resource "aws_elb" "nginx-elb" {
  name                      = "nginx-elb"
  subnets                   = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups           = [aws_security_group.nginx-sg.id]


/*
  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }
*/

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

/*
  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  }
*/

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.web-a.id,aws_instance.web-b.id]
  # cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "nginx-elb"
  }
}