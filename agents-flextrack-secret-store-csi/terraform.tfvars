argocd_apps = [
  {
    app-name = "flextrack-with-secret-store"

    repository-url  = "https://github.com/cloudhein/cluster.git"
    source-path     = "flextrack-secret-store-csi"
    target-revision = "HEAD"

    server-url = "https://kubernetes.default.svc"
  }
]

vpc_id = "vpc-0a3ac4ab297cb22f4"