############################################

variable "root_password" {
  type = "string"
}

############################################

variable "vpc_id" {
  type    = "string"
  default = "uvnet-xmvtqvvy"
}

variable "az" {
  type    = "string"
  default = "cn-bj2-03"
}

variable "image_id" {
  type    = "string"
  default = "uimage-unjymc"
}

variable "subnet_id" {
  type    = "string"
  default = "subnet-etfngm4z"
}

variable "k8s_master_count" {
  type    = "string"
  default = "1"
}

variable "k8s_node_count" {
  type    = "string"
  default = "2"
}

variable "k8s_master_bandwidth" {
  type    = "string"
  default = "1"
}

variable "k8s_node_bandwidth" {
  type    = "string"
  default = "2"
}

variable "env" {
  type = "string"
  default = "dev"
}

variable "k8s_http_bandwidth" {
  type = "string"
  default = "1"
}

variable "k8s_xmpp_bandwidth" {
  type = "string"
  default = "1"
}
