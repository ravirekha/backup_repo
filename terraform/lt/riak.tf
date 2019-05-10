resource "ucloud_instance" "lt_riak1" {
  tag               = "lt_riak1"
  availability_zone = "cn-bj2-03"
  image_id          = "uimage-5fvio2"
  instance_type     = "n-basic-2"

  # use cloud disk as data disk
  boot_disk_size = 30
  boot_disk_type = "local_normal"
  data_disk_size = 50
  data_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip" "lt_riak1" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "lt_riak1"
  tag           = "lt_riak1"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "lt_riak1" {
  resource_id = "${ucloud_instance.lt_riak1.id}"
  eip_id      = "${ucloud_eip.lt_riak1.id}"
}
