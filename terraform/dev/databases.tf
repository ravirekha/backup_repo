resource "ucloud_instance" "dev_db" {
  tag               = "dev_db"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-basic-4"

  # use cloud disk as data disk
  boot_disk_size = 50
  boot_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip_association" "dev_db" {
  count       = 1
  resource_id = "${element(ucloud_instance.dev_db.*.id, count.index)}"
  eip_id      = "${element(ucloud_eip.dev_db.*.id, count.index)}"
}

resource "ucloud_eip" "dev_db" {
  count         = 1
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "${var.env}-dev-db"
  tag           = "tf-${var.env}-dev-db"
  internet_type = "bgp"
}

