resource "yandex_compute_disk" "disk_lb" {
  count = var.lb
  name     = "boot-disk-lb-${count.index + 1}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "20"
  image_id = yandex_compute_image.ubuntu_2004.id
}

resource "yandex_compute_instance" "lb" {
  count = var.lb
  platform_id = "standard-v3"
  name = "lb${count.index + 1}"
  zone     = "ru-central1-a"
  hostname = "lb${count.index + 1}"
  resources {
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk_lb[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnet-1.id
    ip_address = "192.168.10.${40 + count.index + 1}"
    #nat = count.index < 1 ? true : false  # Для первого белый ip для остальных серый
    nat = true
  }

  metadata = {
    user-data = "${file("user_data.yml")}"
  }

}