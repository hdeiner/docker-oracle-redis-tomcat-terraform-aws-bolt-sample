output "redis_dns" {
  value = ["${aws_instance.ec2_redis.*.public_dns}"]
}

output "redis_ip" {
  value = ["${aws_instance.ec2_redis.*.public_ip}"]
}
