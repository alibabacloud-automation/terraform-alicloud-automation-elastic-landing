data "alicloud_ack_service" "open" {
  enable = var.enable_service
  type   = "propayasgo"
}
data "alicloud_log_service" "open" {
  enable = var.enable_service
}
data "alicloud_cms_service" "open" {
  enable = var.enable_service
}