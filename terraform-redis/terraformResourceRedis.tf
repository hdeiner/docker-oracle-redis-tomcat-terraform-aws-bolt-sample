resource "aws_instance" "ec2_redis" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.redis_key_pair.key_name}"
  security_groups = ["${aws_security_group.redis.name}"]
  tags {
    Name = "docker-oracle-redis-tomcat-terraform-aws-bolt-sample Redis ${format("%03d", count.index)}"
  }
}