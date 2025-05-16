#---------MASTER NODE
output "master_ip" {#-------external address
  value = [for i in yandex_compute_instance.master : i.network_interface[0].nat_ip_address]
}

#-------------WORKER NODE
output "worker_ip" {
  value = [for i in yandex_compute_instance.worker : i.network_interface[0].nat_ip_address]
}
#-------------Create inventory file
resource "local_file" "ansible_inventory" {
  content = <<-EOT
    [kube_master]
    %{for i, instance in yandex_compute_instance.master~}
    ${format("kube-master%d ansible_host=%s ansible_user=fill", i + 1, instance.network_interface[0].nat_ip_address)}
    %{endfor~}

    [kube_worker]
    %{for i, instance in yandex_compute_instance.worker~}
    ${format("kube-worker%d ansible_host=%s ansible_user=fill", i + 1, instance.network_interface[0].nat_ip_address)}
    %{endfor~}
  EOT
  filename = "${path.module}/../ansible/inventories/yandex.ini"
}