resource "ucloud_instance" "lt_client1" {
  tag               = "lt_client1"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-highcpu-8"

  # use cloud disk as data disk
  boot_disk_size = 30
  boot_disk_type = "local_normal"
  data_disk_size = 50
  data_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip" "lt_client1" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "lt_client1"
  tag           = "lt_client1"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "lt_client1" {
  resource_id = "${ucloud_instance.lt_client1.id}"
  eip_id      = "${ucloud_eip.lt_client1.id}"
}

resource "ucloud_instance" "lt_client2" {
  tag               = "lt_client2"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-basic-4"

  # use cloud disk as data disk
  boot_disk_size = 30
  boot_disk_type = "local_normal"
  data_disk_size = 50
  data_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip" "lt_client2" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "lt_client2"
  tag           = "lt_client2"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "lt_client2" {
  resource_id = "${ucloud_instance.lt_client2.id}"
  eip_id      = "${ucloud_eip.lt_client2.id}"
}
