resource "aws_key_pair" "aws_key_pair" {
  key_name = "aws_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}