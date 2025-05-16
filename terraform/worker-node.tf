
resource "yandex_compute_disk" "disk_worker" {
  count = var.worker
  name     = "boot-disk-${count.index + 1}"
  type     = "network-hdd"
  zone     = "ru-central1-a"
  size     = "50"
  image_id = yandex_compute_image.ubuntu_2004.id
}

resource "yandex_compute_instance" "worker" {
  count = var.worker
  platform_id = "standard-v3"
  name = "worker${count.index + 1}"
  hostname = "worker${count.index + 1}"
  resources {
    cores         = 2
    memory        = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.disk_worker[count.index].id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    ip_address = "192.168.10.${60 + count.index + 1}"
    #nat = count.index < 1 ? true : false  # Для первого белый ip для остальных серый
    nat = true
  }

  metadata = {
    user-data = "${file("user_data.yml")}"
  }

}