resource "kubernetes_deployment_v1" "Django-API" {
  metadata {
    name = "django-api"
    labels = {
      nome = "django"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        nome = "django"
      }
    }

    template {
      metadata {
        labels = {
          nome = "django"
        }
      }

      spec {
        container {
          image = "leodosurf/app-node:1.0"
          name  = "django"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/clientes/"
              port = 8000
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "LoadBalancer" {
  metadata {
    name = "load-balancer-django-api"
  }
  spec {
    selector = {
      nome = "django"
    }
    port {
      port = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}

data "kubernetes_service_v1" "nomeDNS" {
    metadata {
      name = "load-balancer-django-api"
    }
}

output "URL" {
  value = data.kubernetes_service_v1.nomeDNS.status
}