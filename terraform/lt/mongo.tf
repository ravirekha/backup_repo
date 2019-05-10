resource "ucloud_instance" "lt_mongodb1" {
  tag               = "lt_mongodb1"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-highcpu-8"

  # use cloud disk as data disk
  boot_disk_size = 30
  boot_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_disk_attachment" "lt_mongodb1" {
  availability_zone = "${var.az}"
  disk_id           = "bsm-x4ull3s4"
  instance_id       = "${ucloud_instance.lt_mongodb1.id}"
}

resource "ucloud_eip" "lt_mongodb1" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "lt_mongodb1"
  tag           = "lt_mongodb1"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "lt_mongodb1" {
  resource_id = "${ucloud_instance.lt_mongodb1.id}"
  eip_id      = "${ucloud_eip.lt_mongodb1.id}"
}
