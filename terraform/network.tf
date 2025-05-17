resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet-1" {
  name           = "k8s-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  route_table_id = yandex_vpc_route_table.egress.id
}

# resource "yandex_vpc_subnet" "k8s-subnet-2" {
#   name           = "k8s-subnet-2"
#   zone           = "ru-central1-b"
#   network_id     = yandex_vpc_network.k8s-network.id
#   v4_cidr_blocks = ["192.168.20.0/24"]
# }

# resource "yandex_vpc_subnet" "k8s-subnet-3" {
#   name           = "k8s-subnet-3"
#   zone           = "ru-central1-d"
#   network_id     = yandex_vpc_network.k8s-network.id
#   v4_cidr_blocks = ["192.168.30.0/24"]
# }
