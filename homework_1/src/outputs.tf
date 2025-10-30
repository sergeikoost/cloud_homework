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
EOT
}
