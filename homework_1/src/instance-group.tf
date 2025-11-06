# Целевая группа для балансировщика
resource "yandex_lb_target_group" "web_group" {
  name = "web-target-group"

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.web_group.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.web_group.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.public.id
    address   = yandex_compute_instance_group.web_group.instances[2].network_interface[0].ip_address
  }
}

# Группа виртуальных машин
resource "yandex_compute_instance_group" "web_group" {
  name               = "web-instance-group"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.storage_sa.id

  instance_template {
    platform_id = "standard-v3"
    
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
      network_id = yandex_vpc_network.main.id
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
          - mysql-server
          - php-mysql
        runcmd:
          - systemctl enable apache2
          - systemctl start apache2
          - echo "<!DOCTYPE html>
                <html>
                <head>
                    <title>LAMP Stack</title>
                </head>
                <body>
                    <h1>Welcome to LAMP Stack!</h1>
                    <p>Instance: $(hostname)</p>
                    <p>Current time: $(date)</p>
                </body>
                </html>" > /var/www/html/index.html
          - chown www-data:www-data /var/www/html/index.html
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

  # Проверка состояния ВМ
  health_check {
    interval = 30
    timeout  = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    
    http_options {
      port = 80
      path = "/"
    }
  }

  # Зависимость от создания бакета
  depends_on = [
    yandex_storage_bucket.student_bucket,
    yandex_storage_object.web_image
  ]
}

# Сервисный аккаунт для доступа к storage
resource "yandex_iam_service_account" "storage_sa" {
  name        = "storage-sa"
  description = "Service account for storage access"
}

# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "storage_viewer" {
  folder_id = var.yc_folder_id
  role      = "storage.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.storage_sa.id}"
}