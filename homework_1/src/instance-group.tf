# Группа виртуальных машин
# Группа виртуальных машин
resource "yandex_compute_instance_group" "web_group" {
  name               = "web-instance-group"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.storage-sa.id

  instance_template {
    platform_id = "standard-v3"
    service_account_id = yandex_iam_service_account.storage-sa.id
    
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"  # LAMP image
        size     = 10
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat        = true
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
      user-data = <<-EOF
        #cloud-config
        packages:
          - apache2
          - php
          - libapache2-mod-php
        runcmd:
          - systemctl enable apache2
          - systemctl start apache2
          - echo "<?php echo '<h1>Welcome to LAMP Stack!</h1><p>Instance: ' . gethostname() . '</p><p><img src=\"https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.web_image.key}\" width=\"200\"></p>'; ?>" > /var/www/html/index.php
          - chown www-data:www-data /var/www/html/index.php
        EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.yc_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  health_check {
    interval = 30
    timeout  = 10
    http_options {
      port = 80
      path = "/"
    }
  }
}

# Целевая группа для балансировщика
resource "yandex_lb_target_group" "web_group" {
  name = "web-target-group"
  
  # Динамически добавляем все ВМ из группы
  dynamic "target" {
    for_each = yandex_compute_instance_group.web_group.instances
    content {
      subnet_id = yandex_vpc_subnet.public.id
      address   = target.value.network_interface.0.ip_address
    }
  }
}