


resource "kubernetes_manifest" "frontend_svc" {
  manifest = yamldecode(file("${local.manifest_path}/frontend-svc.yaml"))
}

resource "kubernetes_manifest" "database_svc" {
  manifest = yamldecode(file("${local.manifest_path}/database-svc.yaml"))
}


resource "kubernetes_manifest" "backend_svc" {
  manifest = yamldecode(file("${local.manifest_path}/backend-svc.yaml"))
}


resource "kubernetes_manifest" "database_depl" {
  manifest   = yamldecode(file("${local.manifest_path}/database-depl.yaml"))
  depends_on = [kubernetes_secret.database_secrets]
}

resource "kubernetes_manifest" "backend_depl" {
  manifest   = yamldecode(file("${local.manifest_path}/backend-depl.yaml"))
  depends_on = [kubernetes_secret.backend_secrets]
}

resource "kubernetes_manifest" "frontend_depl" {
  manifest   = yamldecode(file("${local.manifest_path}/frontend-depl.yaml"))
  depends_on = [kubernetes_secret.frontend_secrets]
}


resource "kubernetes_manifest" "ingress" {
  manifest = yamldecode(file("${local.manifest_path}/ingress.yaml"))
}



