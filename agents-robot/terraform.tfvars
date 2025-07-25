argocd_apps = [
  {
    app-name = "flextrack-app"

    repository-url  = "https://github.com/cloudhein/cluster.git"
    source-path     = "robot-shop"
    target-revision = "HEAD"

    server-url = "https://kubernetes.default.svc"
  }
]