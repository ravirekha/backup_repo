# Master nodes
resource "ucloud_instance" "k8s_masters" {
  count             = "${var.k8s_master_count}"
  tag               = "tf-${var.env}-k8s-master"
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

resource "ucloud_eip_association" "k8s_master" {
  count       = "${var.k8s_master_count}"
  resource_id = "${element(ucloud_instance.k8s_masters.*.id, count.index)}"
  eip_id      = "${element(ucloud_eip.k8s_master.*.id, count.index)}"
}

# Worker nodes
resource "ucloud_instance" "k8s_nodes" {
  count             = "${var.k8s_node_count}"
  tag               = "tf-${var.env}-k8s-node"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-highcpu-16"

  # use cloud disk as data disk
  boot_disk_size = 50
  boot_disk_type = "local_normal"
  data_disk_size = 100
  data_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip_association" "k8s_nodes" {
  count       = "${var.k8s_node_count}"
  resource_id = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  eip_id      = "${element(ucloud_eip.k8s_node.*.id, count.index)}"
}

# API LB
resource "ucloud_lb" "k8s_api" {
  tag       = "tf-${var.env}-k8s-api"
  internal  = false
  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_lb_listener" "k8s_api" {
  load_balancer_id = "${ucloud_lb.k8s_api.id}"
  protocol         = "tcp"
  port             = "443"
}

resource "ucloud_security_group" "k8s_api_sg" {
  tag = "tf-${var.env}-k8s_api_sg"

  rules {
    port_range = "443"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    policy     = "accept"
  }
}

resource "ucloud_lb_attachment" "k8s_api" {
  count            = "${var.k8s_master_count}"
  load_balancer_id = "${ucloud_lb.k8s_api.id}"
  listener_id      = "${ucloud_lb_listener.k8s_api.id}"
  resource_id      = "${element(ucloud_instance.k8s_masters.*.id, count.index)}"
  port             = 6443
}

resource "ucloud_eip_association" "k8s_api" {
  resource_id = "${ucloud_lb.k8s_api.id}"
  eip_id      = "${ucloud_eip.k8s_api.id}"
}

# chat HTTP/HTTPS LB
resource "ucloud_lb" "k8s_svc_http" {
  tag       = "tf-${var.env}-k8s-srv_http"
  internal  = false
  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip_association" "k8s_svc_http" {
  resource_id = "${ucloud_lb.k8s_svc_http.id}"
  eip_id      = "${ucloud_eip.k8s_svc_http.id}"
}

resource "ucloud_lb_listener" "k8s_svc_http" {
  load_balancer_id = "${ucloud_lb.k8s_svc_http.id}"
  protocol         = "tcp"
  port             = "80"
}

resource "ucloud_lb_listener" "k8s_svc_https" {
  load_balancer_id = "${ucloud_lb.k8s_svc_http.id}"
  protocol         = "tcp"
  port             = "443"
}

resource "ucloud_security_group" "k8s_svc_http_sg" {
  tag = "tf-${var.env}-k8s_svc_http_sg"

  rules {
    port_range = "80"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    policy     = "accept"
  }

  rules {
    port_range = "443"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    policy     = "accept"
  }
}

resource "ucloud_lb_attachment" "k8s_svc_http" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_http.id}"
  listener_id      = "${ucloud_lb_listener.k8s_svc_http.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30000
}

resource "ucloud_lb_attachment" "k8s_svc_https" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_http.id}"
  listener_id      = "${ucloud_lb_listener.k8s_svc_https.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30001
}

# chat ejabberd LB external
resource "ucloud_lb" "k8s_svc_xmpp" {
  tag       = "tf-${var.env}-k8s-srv_xmpp"
  internal  = false
  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip_association" "k8s_svc_xmpp" {
  resource_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  eip_id      = "${ucloud_eip.k8s_svc_xmpp.id}"
}

resource "ucloud_lb_listener" "k8s_xmpp_http" {
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  protocol         = "tcp"
  port             = "80"
}

resource "ucloud_lb_listener" "k8s_xmpp_https" {
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  protocol         = "tcp"
  port             = "443"
}

resource "ucloud_lb_listener" "k8s_xmpp_c2s" {
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  protocol         = "tcp"
  port             = "5222"
}

resource "ucloud_lb_listener" "k8s_xmpp_s2s" {
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  protocol         = "tcp"
  port             = "5269"
}

resource "ucloud_security_group" "k8s_svc_xmpp_sg" {
  tag = "tf-${var.env}-k8s_svc_lb_sg"

  rules {
    port_range = "5222"
    protocol   = "tcp"
    cidr_block = "0.0.0.0/0"
    policy     = "accept"
  }
}

resource "ucloud_lb_attachment" "k8s_svc_xmpp_http" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  listener_id      = "${ucloud_lb_listener.k8s_xmpp_http.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30000
}

resource "ucloud_lb_attachment" "k8s_svc_xmpp_https" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  listener_id      = "${ucloud_lb_listener.k8s_xmpp_https.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30001
}

resource "ucloud_lb_attachment" "k8s_svc_xmpp_c2s" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  listener_id      = "${ucloud_lb_listener.k8s_xmpp_c2s.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30002
}

resource "ucloud_lb_attachment" "k8s_svc_xmpp_s2s" {
  count            = "${var.k8s_node_count}"
  load_balancer_id = "${ucloud_lb.k8s_svc_xmpp.id}"
  listener_id      = "${ucloud_lb_listener.k8s_xmpp_c2s.id}"
  resource_id      = "${element(ucloud_instance.k8s_nodes.*.id, count.index)}"
  port             = 30003
}


# chat ejabberd LB internal
resource "ucloud_instance" "loadtest_lb1" {
  tag               = "loadtest_lb1-${var.env}"
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

resource "ucloud_eip" "loadtest_lb1" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  name          = "loadtest_lb1"
  tag           = "loadtest_lb1-${var.env}"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "loadtest_lb1" {
  resource_id = "${ucloud_instance.loadtest_lb1.id}"
  eip_id      = "${ucloud_eip.loadtest_lb1.id}"
}

# Metrics proxy
resource "ucloud_instance" "loadtest_mp1" {
  tag               = "loadtest_mp-${var.env}"
  availability_zone = "${var.az}"
  image_id          = "${var.image_id}"
  instance_type     = "n-basic-2"

  # use cloud disk as data disk
  boot_disk_size = 30
  boot_disk_type = "local_normal"
  root_password  = "${var.root_password}"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"
}

resource "ucloud_eip" "loadtest_mp1" {
  bandwidth     = 10
  charge_mode   = "bandwidth"
  name          = "loadtest_mp1"
  tag           = "loadtest_mp1-${var.env}"
  internet_type = "bgp"
}

resource "ucloud_eip_association" "loadtest_mp1" {
  resource_id = "${ucloud_instance.loadtest_mp1.id}"
  eip_id      = "${ucloud_eip.loadtest_mp1.id}"
}

# Network adapters
resource "ucloud_eip" "k8s_master" {
  count         = "${var.k8s_master_count}"
  bandwidth     = "${var.k8s_master_bandwidth}"
  charge_mode   = "bandwidth"
  name          = "k8s-master"
  tag           = "tf-${var.env}-k8s-master"
  internet_type = "bgp"
}

resource "ucloud_eip" "k8s_node" {
  count         = "${var.k8s_node_count}"
  bandwidth     = "${var.k8s_node_bandwidth}"
  charge_mode   = "bandwidth"
  name          = "k8s-node"
  tag           = "tf-${var.env}-k8s-node"
  internet_type = "bgp"
}

resource "ucloud_eip" "k8s_api" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  tag           = "tf-${var.env}-k8s_api"
  internet_type = "bgp"
}

resource "ucloud_eip" "k8s_svc_http" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  tag           = "tf-${var.env}-k8s_svc_http"
  internet_type = "bgp"
}

resource "ucloud_eip" "k8s_svc_xmpp" {
  bandwidth     = 1
  charge_mode   = "bandwidth"
  tag           = "tf-${var.env}-k8s_svc_xmpp"
  internet_type = "bgp"
}

