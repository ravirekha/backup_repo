output "k8s_master_ip" {
  value = "${ucloud_instance.k8s_masters.*.ip_set}"
}

output "k8s node_ip" {
  value = "${ucloud_instance.k8s_nodes.*.ip_set}"
}

output "Internal LB" {
  value = "${ucloud_instance.k8s_lb_int.ip_set}"
}

# databases
output "database host" {
  value = "${ucloud_instance.dev_db.ip_set}"
}

# API LB
output "k8s_lb_api_public_api" {
  value = "${ucloud_lb.k8s_api.ip_set.0.ip}"
}

output "k8s_lb_api_create_time" {
  value = "${ucloud_lb.k8s_api.create_time}"
}

# XMPP LB
output "k8s_lb_xmpp_public_ip" {
  value = "${ucloud_lb.k8s_svc_xmpp.ip_set.0.ip}"
}

output "k8s_lb_xmpp_create_time" {
  value = "${ucloud_lb.k8s_svc_xmpp.create_time}"
}

# HTTP LB
output "k8s_lb_http_public_ip" {
  value = "${ucloud_lb.k8s_svc_http.ip_set.0.ip}"
}
