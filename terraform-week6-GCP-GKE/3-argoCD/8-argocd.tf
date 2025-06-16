resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}


resource "time_sleep" "wait_for_argocd_server" {
  depends_on      = [helm_release.argocd]
  create_duration = "60s"
}


resource "argocd_application" "cyf_hotel_prod" {
  depends_on = [helm_release.argocd, time_sleep.wait_for_argocd_server]
  metadata {
    name      = "cyf-hotel-prod"
    namespace = "argocd"
  }
  spec {
    project = "default"
    source {
      repo_url        = "https://github.com/${local.repo_owner}/${local.watched_repo_name}"
      path            = "manifest-argo"
      target_revision = "main"
      kustomize {
        patches {
          target {
            kind = "Deployment"
            name = "backend"
          }
          patch = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3
EOF
        }
        patches {
          target {
            kind = "ExternalSecret"
            name = "backend-secrets"
          }
          patch = <<EOF
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: backend-secrets
spec:
  data:
  - secretKey: argo_prod_db_url
    remoteRef:
      key: argo-prod-db-url
EOF
        }
        patches {
          target {
            kind = "Deployment"
            name = "backend"
          }
          patch = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  template:
    spec:
      containers:
      - name: backend
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              key: argo_prod_db_url
EOF
        }
      }
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argo-prod"
    }
    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
      sync_options = ["CreateNamespace=true"]
    }
  }
}


output "argo_ip" {
  value = data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip
}

output "argo_pw" {
  value     = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  sensitive = true
}
