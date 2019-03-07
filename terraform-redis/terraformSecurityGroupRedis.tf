resource "aws_security_group" "redis" {
  name = "docker-oracle-redis-tomcat-terraform-aws-bolt-sample-redis"
  description = "docker-oracle-redis-tomcat-terraform-aws-bolt-sample Redis Access"
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 6379
    to_port = 6379
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  tags {
    Name = "docker-oracle-redis-tomcat-terraform-aws-bolt-sample Redis Access"
  }
}