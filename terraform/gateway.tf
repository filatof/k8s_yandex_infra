resource "yandex_vpc_gateway" "egress-gateway" {
  name      = "gateway"
  folder_id = var.yc_folder_id
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "egress" {
  name       = "egress"
  network_id = yandex_vpc_network.k8s-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }
}
