argocd_apps = [
  {
    app-name = "flextrack-app"

    repository-url  = "https://github.com/cloudhein/flextrack-microservices.git"
    source-path     = "flextrack-local-kind"
    target-revision = "HEAD"

    server-url = "https://kubernetes.default.svc"
  }
]