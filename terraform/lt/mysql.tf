# Create database instance
resource "ucloud_db_instance" "lt-ws_mysql" {
  availability_zone = "${var.az}"
  name              = "lt-ws-mysql"
  instance_storage  = 50
  instance_type     = "percona-ha-8"
  engine            = "percona"
  engine_version    = "5.6"
  password          = "${var.mysql_password}"
  tag               = "lt-ws-mysql"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"

  # Backup policy
  backup_begin_time = 10
  backup_count      = 2
  backup_date       = "0010001"
  backup_black_list = ["test.%"]
}

# Create database instance
resource "ucloud_db_instance" "lt-api_mysql" {
  availability_zone = "${var.az}"
  name              = "lt-api-mysql"
  instance_storage  = 50
  instance_type     = "percona-ha-8"
  engine            = "percona"
  engine_version    = "5.6"
  password          = "${var.mysql_password}"
  tag               = "lt-api-mysql"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"

  # Backup policy
  backup_begin_time = 10
  backup_count      = 1
  backup_date       = "0010001"
  backup_black_list = ["test.%"]
}

# Create database instance
resource "ucloud_db_instance" "lt-ejabberd_mysql" {
  availability_zone = "${var.az}"
  name              = "lt-ejabberd-mysql"
  instance_storage  = 50
  instance_type     = "percona-ha-12"
  engine            = "percona"
  engine_version    = "5.6"
  password          = "${var.mysql_password}"
  tag               = "lt-ejabberd-mysql"

  vpc_id    = "${var.vpc_id}"
  subnet_id = "${var.subnet_id}"

  # Backup policy
  backup_begin_time = 10
  backup_count      = 1
  backup_date       = "0010001"
  backup_black_list = ["test.%"]
}
