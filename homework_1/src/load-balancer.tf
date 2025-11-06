# Сетевой балансировщик нагрузки
resource "yandex_lb_network_load_balancer" "web_nlb" {
  name = "web-network-lb"

  listener {
    name = "web-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.web_group.id

    healthcheck {
      name = "http-healthcheck"
      interval = 2
      timeout = 1
      unhealthy_threshold = 2
      healthy_threshold = 2
      
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

#  Application Load Balancer
resource "yandex_alb_load_balancer" "web_alb" {
  name               = "web-application-lb"
  network_id         = yandex_vpc_network.main.id

  allocation_policy {
    location {
      zone_id   = var.yc_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web_router.id
      }
    }
  }
}

# HTTP router для ALB
resource "yandex_alb_http_router" "web_router" {
  name = "web-router"
}

# VH для ALB
resource "yandex_alb_virtual_host" "web_host" {
  name           = "web-host"
  http_router_id = yandex_alb_http_router.web_router.id
  
  route {
    name = "web-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web_backend.id
      }
    }
  }
}

# Backend для ALB
resource "yandex_alb_backend_group" "web_backend" {
  name = "web-backend-group"

  http_backend {
    name             = "web-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_lb_target_group.web_group.id]
    
    healthcheck {
      timeout          = "1s"
      interval         = "2s"
      healthcheck_port = 80
      
      http_healthcheck {
        path = "/"
      }
    }
  }
}
