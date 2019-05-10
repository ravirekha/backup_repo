# chat-loadtest1.oncam.com
resource "ucloud_instance" "lt_lb1" {
  tag               = "lt_lb1"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-basic-2"

  # use cloud disk as data disk
  boot_disk_size = 50
  boot_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip" "lt_lb1" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "lt_lb1"
  tag           = "lt_lb1"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "lt_lb1" {
  resource_id = "${ucloud_instance.lt_lb1.id}"
  eip_id      = "${ucloud_eip.lt_lb1.id}"
}
