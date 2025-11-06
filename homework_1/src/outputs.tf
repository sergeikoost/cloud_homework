output "nat_instance_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

output "public_vm_ip" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "private_vm_internal_ip" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}


output "bucket_name" {
  value = yandex_storage_bucket.student_bucket.bucket
}


output "image_url" {
  value = "https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.web_image.key}"
}

output "network_lb_ip" {
  value = one(yandex_lb_network_load_balancer.web_nlb.listener[*].external_address_spec[0].address)
}


output "application_lb_ip" {
  value = one(yandex_alb_load_balancer.web_alb.listener[*].endpoint[0].address[0].external_ipv4_address[0].address)
}

output "instance_group_ips" {
  value = yandex_compute_instance_group.web_group.instances[*].network_interface[0].ip_address
}

output "connection_instructions" {
  value = <<EOT

=== ОСНОВНАЯ ИНФРАСТРУКТУРА ===
NAT-инстанс: ${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
Публичная виртуалка: ${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address}
Приватная виртуалка: ${yandex_compute_instance.private-vm.network_interface.0.ip_address}

=== OBJECT STORAGE ===
Бакет: ${yandex_storage_bucket.student_bucket.bucket}
Ссылка на картинку: https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.web_image.key}

=== LOAD BALANCERS ===
Network Load Balancer: http://${one(yandex_lb_network_load_balancer.web_nlb.listener[*].external_address_spec[0].address)}
Application Load Balancer: http://${one(yandex_alb_load_balancer.web_alb.listener[*].endpoint[0].address[0].external_ipv4_address[0].address)}

=== INSTANCE GROUP ===
ВМ в группе: ${join(", ", yandex_compute_instance_group.web_group.instances[*].network_interface[0].ip_address)}

=== ТЕСТИРОВАНИЕ ===
1. Проверить Network LB: curl http://${one(yandex_lb_network_load_balancer.web_nlb.listener[*].external_address_spec[0].address)}
2. Проверить Application LB: curl http://${one(yandex_alb_load_balancer.web_alb.listener[*].endpoint[0].address[0].external_ipv4_address[0].address)}
3. Удалить одну ВМ из группы и проверить работу балансировщика
EOT
}