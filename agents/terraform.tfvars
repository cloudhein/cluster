argocd_apps = [
  {
    app-name = "flextrack-app"

    repository-url  = "https://github.com/cloudhein/cluster.git"
    source-path     = "flextrack"
    target-revision = "head"

    server-url = "https://kubernetes.default.svc"
  }
]