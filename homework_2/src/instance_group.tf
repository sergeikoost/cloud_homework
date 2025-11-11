# Группа безопасности для LAMP инстансов
resource "yandex_vpc_security_group" "lamp-sg" {
  name        = "lamp-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    description    = "Outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Группа виртуальных машин
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.storage_admin.id

  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" # LAMP image
        size     = 10
      }
    }

    network_interface {
      subnet_ids = [yandex_vpc_subnet.public.id]
      nat       = true
      security_group_ids = [yandex_vpc_security_group.lamp-sg.id]
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
      user-data = <<-EOF
        #!/bin/bash
        apt-get update
        apt-get install -y apache2 php libapache2-mod-php mysql-client
        
        # Создаем веб-страницу с ссылкой на картинку
        cat > /var/www/html/index.html << 'EOL'
        <!DOCTYPE html>
        <html>
        <head>
            <title>LAMP Instance</title>
        </head>
        <body>
            <h1>Welcome to LAMP Instance</h1>
            <p>Instance IP: $(hostname -I)</p>
            <p>Image from Object Storage:</p>
            <img src="https://netology-hm-bucket.storage.yandexcloud.net/yandex.png" alt="Test Image" width="400">
            <br>
            <a href="https://netology-hm-bucket.storage.yandexcloud.net/yandex.png">Direct link to image</a>
        </body>
        </html>
        EOL
        
        systemctl restart apache2
        systemctl enable apache2
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
    timeout = 1
    interval = 2
    healthy_threshold = 3
    unhealthy_threshold = 3
    http_options {
      port = 80
      path = "/"
    }
  }

  load_balancer {
    target_group_name = "lamp-target-group"
  }
}

# Сетевой балансировщик
resource "yandex_lb_network_load_balancer" "lamp_balancer" {
  name = "lamp-network-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp_group.load_balancer.0.target_group_id

    healthcheck {
      name = "http-healthcheck"
      timeout = 1
      interval = 2
      healthy_threshold = 3
      unhealthy_threshold = 3
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}