# Публичный IP NAT-инстанса
output "nat_instance_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

# Публичный IP виртуалки в публичной подсети
output "public_vm_ip" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

# Внутренний IP виртуалки в приватной подсети
output "private_vm_internal_ip" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}

# URL бакета и картинки
output "bucket_url" {
  value = "https://netology-hm-bucket.storage.yandexcloud.net"
}

output "image_url" {
  value = "https://netology-hm-bucket.storage.yandexcloud.net/yandex.png"
}

output "load_balancer_ip" {
  value = yandex_lb_network_load_balancer.lamp_balancer.listener.*.external_address_spec[0].*.address[0]
}

# Инструкции для подключения и проверки
output "connection_instructions" {
  value = <<EOT

=== ИНСТРУКЦИИ ДЛЯ ПОДКЛЮЧЕНИЯ ===

1. Подключиться к публичной виртуалке:
   ssh ubuntu@${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address}

2. Проверить доступ в интернет с публичной виртуалки:
   ping -c 3 8.8.8.8

3. Подключиться к приватной виртуалке через публичную:
   ssh ubuntu@${yandex_compute_instance.private-vm.network_interface.0.ip_address}

4. Проверить доступ в интернет с приватной виртуалки:
   ping -c 3 8.8.8.8

=== АДРЕСА ===
NAT-инстанс: ${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
Публичная виртуалка: ${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address}
Приватная виртуалка: ${yandex_compute_instance.private-vm.network_interface.0.ip_address}

=== OBJECT STORAGE ===
Bucket URL: https://netology-hm-bucket.storage.yandexcloud.net
Image URL: https://netology-hm-bucket.storage.yandexcloud.net/image.jpg

=== LOAD BALANCER ===
Load Balancer IP: ${yandex_lb_network_load_balancer.lamp_balancer.listener.*.external_address_spec[0].*.address[0]}

5. Для проверки балансировщика:
   curl http://${yandex_lb_network_load_balancer.lamp_balancer.listener.*.external_address_spec[0].*.address[0]}

6. Чтобы проверить отказоустойчивость, удалите одну из ВМ:
   yc compute instance delete <instance-id>
EOT
}