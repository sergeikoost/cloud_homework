# Основная инфраструктура
output "nat_instance_ip" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

output "public_vm_ip" {
  value = yandex_compute_instance.public-vm.network_interface.0.nat_ip_address
}

output "private_vm_internal_ip" {
  value = yandex_compute_instance.private-vm.network_interface.0.ip_address
}

# Object Storage
output "bucket_name" {
  value = yandex_storage_bucket.student_bucket.bucket
}

output "image_url" {
  value = "https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.web_image.key}"
}

# Instance Group
output "instance_group_ips" {
  value = yandex_compute_instance_group.web_group.instances[*].network_interface.0.ip_address
}

# Load Balancer
output "network_lb_info" {
  value = "Network Load Balancer создан: ${yandex_lb_network_load_balancer.web_nlb.name}"
}

# Простые инструкции
output "instructions" {
  value = <<EOT
=== ИНСТРУКЦИИ ===

1. Object Storage:
   - Бакет: ${yandex_storage_bucket.student_bucket.bucket}
   - Картинка: https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.web_image.key}

2. Instance Group:
   - Создано ${length(yandex_compute_instance_group.web_group.instances)} ВМ
   - IP адреса: ${join(", ", yandex_compute_instance_group.web_group.instances[*].network_interface.0.ip_address)}

3. Load Balancer создан - проверьте IP в веб-консоли

4. Базовая инфраструктура:
   - Public VM: ${yandex_compute_instance.public-vm.network_interface.0.nat_ip_address}
   - Private VM: ${yandex_compute_instance.private-vm.network_interface.0.ip_address}
EOT
}