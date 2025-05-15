# Compute instance group for control-plane

resource "yandex_compute_instance_group" "k8s-masters" {
  name               = "kube-masters"
  service_account_id = yandex_iam_service_account.for-autoscale.id #var.service_account_id
  
  instance_template {

    name = "master-{instance.index}"

    platform_id = "standard-v3"
    
    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
    boot_disk {
      initialize_params {
        image_id = "fd87j6d92jlrbjqbl32q"
        size     = 10
        type     = "network-ssd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      nat = true
    }

    metadata = {
      user-data = "${file("~/metafile.yaml")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }
}

# Compute instance group for workers

resource "yandex_compute_instance_group" "k8s-workers" {
  name               = "kube-workers"
  service_account_id = yandex_iam_service_account.for-autoscale.id  #var.service_account_id
  
  instance_template {

    name = "worker-{instance.index}"

    platform_id = "standard-v3"

    resources {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }

    boot_disk {
      initialize_params {
        image_id = "fd87j6d92jlrbjqbl32q"
        size     = 10
        type     = "network-hdd"
      }
    }

    network_interface {
      network_id = yandex_vpc_network.k8s-network.id
      subnet_ids = [
        yandex_vpc_subnet.k8s-subnet-1.id,
        yandex_vpc_subnet.k8s-subnet-2.id,
        yandex_vpc_subnet.k8s-subnet-3.id,
      ]
      nat = true
    }

    metadata = {
      user-data = "${file("~/metafile.yaml")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    zones = [
      "ru-central1-a",
      "ru-central1-b",
      "ru-central1-d",
    ]
  }

  deploy_policy {
    max_unavailable = 1
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 1
  }
}

# Compute instance group for the LB

# resource "yandex_compute_instance_group" "k8s-haproxy" {
#   name               = "kube-haproxy"
#   service_account_id = yandex_iam_service_account.for-autoscale.id #var.service_account_id

#   instance_template {

#     name = "haproxy-{instance.index}"

#     platform_id = "standard-v3"

#     resources {
#       cores         = 2
#       memory        = 2
#       core_fraction = 20
#     }

#     boot_disk {
#       initialize_params {
#         image_id = "fd87j6d92jlrbjqbl32q"
#         size     = 10
#         type     = "network-hdd"
#       }
#     }

#     network_interface {
#       network_id = yandex_vpc_network.k8s-network.id
#       subnet_ids = [
#         yandex_vpc_subnet.k8s-subnet-1.id,
#         yandex_vpc_subnet.k8s-subnet-2.id,
#         yandex_vpc_subnet.k8s-subnet-3.id,
#       ]
#       nat = true
#     }

#     metadata = {
#       user-data = "${file("~/metafile.yaml")}"
#     }
#     network_settings {
#       type = "STANDARD"
#     }
#   }

#   scale_policy {
#     fixed_scale {
#       size = 1
#     }
#   }

#   allocation_policy {
#     zones = [
#       "ru-central1-a",
#       "ru-central1-b",
#       "ru-central1-d",
#     ]
#   }

#   deploy_policy {
#     max_unavailable = 1
#     max_creating    = 1
#     max_expansion   = 1
#     max_deleting    = 1
#   }
# }
