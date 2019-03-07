resource "aws_key_pair" "redis_key_pair" {
  key_name = "redis_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}