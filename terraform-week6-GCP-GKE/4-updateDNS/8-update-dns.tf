variable "current_namespace" {
  default = "default"
}

resource "time_sleep" "wait_for_ingress" {
  create_duration = "300s"
}

data "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "app-ingress"
    namespace = var.current_namespace
  }
  depends_on = [time_sleep.wait_for_ingress]
}


locals {
  ingress_status = try(data.kubernetes_ingress_v1.ingress.status[0].load_balancer[0].ingress[0], {})
  hostname       = try(local.ingress_status.hostname, "")
  ip             = try(local.ingress_status.ip, "IP not yet assigned")
  host           = try(data.kubernetes_ingress_v1.ingress.spec[0].rule[0].host, "")
  ingress_url    = coalesce(local.hostname, local.host, local.ip, "IP not yet assigned")


}

data "http" "ddns_update" {
  url        = "https://www.duckdns.org/update?domains=${local.duckdns_domain}&token=${var.duckdns_token}&ip=${local.ip}"
  depends_on = [time_sleep.wait_for_ingress]
}



output "dns_info" {
  depends_on = [data.kubernetes_ingress_v1.ingress]
  value = {
    http_response = data.http.ddns_update.response_body
    url           = local.ingress_url
    ip            = local.ip
  }
}

