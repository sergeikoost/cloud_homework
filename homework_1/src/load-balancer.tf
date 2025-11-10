# Network Load Balancer
# Network Load Balancer
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
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}