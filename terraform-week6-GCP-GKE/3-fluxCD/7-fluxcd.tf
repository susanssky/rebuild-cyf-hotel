
resource "kubernetes_namespace" "flux_prod" {
  metadata {
    name = "flux-prod"
  }
}

resource "github_repository" "this" {
  name       = local.flux_repo_name
  visibility = "public"
  auto_init  = true

}

resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository.this]

  embedded_manifests = true
  path               = "clusters/my-cluster"
}


locals {
  files = fileset("../../manifest-flux/", "*.yaml")
}

resource "github_repository_file" "example" {
  depends_on          = [flux_bootstrap_git.this]
  for_each            = local.files
  repository          = local.flux_repo_name
  branch              = "main"
  file                = "clusters/my-cluster/${each.key}"
  content             = file("../../manifest-flux/${each.key}")
  commit_message      = "Add ${each.key} via Terraform"
  overwrite_on_create = true
}
