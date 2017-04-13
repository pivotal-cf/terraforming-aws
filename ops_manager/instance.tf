resource "aws_instance" "ops_manager" {
  ami                    = "${var.ami}"
  instance_type          = "m3.medium"
  key_name               = "${aws_key_pair.ops_manager.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ops_manager_security_group.id}"]
  source_dest_check      = false
  subnet_id              = "${var.subnet_id}"
  count                  = "${var.count}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  tags {
    Name = "${var.env_name}-ops-manager"
  }
}
