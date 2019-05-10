output "k8s_master_ip" {
  value = "${ucloud_instance.k8s_masters.*.ip_set}"
}

output "k8s node_ip" {
  value = "${ucloud_instance.k8s_nodes.*.ip_set}"
}

output "metrics proxy IP" {
  value = "${ucloud_instance.loadtest_mp1.*.ip_set}"
}

output "internal LB IP" {
  value = "${ucloud_instance.loadtest_lb1.ip_set}"
}

# API LB
output "k8s_lb_api_public_ip" {
  value = "${ucloud_lb.k8s_api.ip_set.0.ip}"
}

output "k8s_lb_api_private_ip" {
  value = "${ucloud_lb.k8s_api.private_ip}"
}

output "k8s_lb_api_create_time" {
  value = "${ucloud_lb.k8s_api.create_time}"
}

# XMPP LB
output "k8s_lb_xmpp_public_ip" {
  value = "${ucloud_lb.k8s_svc_xmpp.ip_set.0.ip}"
}

output "k8s_lb_xmpp_private_ip" {
  value = "${ucloud_lb.k8s_svc_xmpp.private_ip}"
}

output "k8s_lb_xmpp_create_time" {
  value = "${ucloud_lb.k8s_svc_xmpp.create_time}"
}

# HTTP LB
output "k8s_lb_http_public_ip" {
  value = "${ucloud_lb.k8s_svc_http.ip_set.0.ip}"
}

output "k8s_lb_http_private_ip" {
  value = "${ucloud_lb.k8s_svc_http.private_ip}"
}

output "k8s_lb_http_create_time" {
  value = "${ucloud_lb.k8s_svc_http.create_time}"
}

output "k8s_int_lb_ip" {
  value = "${ucloud_instance.loadtest_lb1.ip_set}"
}
