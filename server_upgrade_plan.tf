resource "kubernetes_manifest" "system_upgrade" {
  manifest = {
    apiVersion = "upgrade.cattle.io/v1"
    kind       = "Plan"

    metadata = {
      name      = "server-upgrade-plan"
      namespace = "system-upgrade"
      labels = {
        "k3s-upgrade" = "server"
      }
    }

    spec = {
      channel     = "https://update.k3s.io/v1-release/channels/${var.k3s_channel}"
      concurrency = "1"
      cordon      = true
      drain = {
        force            = true
        deleteLocalData  = true
        ignoreDaemonSets = true
      }
      serviceAccountName = "system-upgrade"
      upgrade = {
        image = "rancher/k3s-upgrade"
      }
      nodeSelector = {
        matchExpressions = [
          {
            key      = "node-role.kubernetes.io/master"
            operator = "In"
            values   = ["true"]
          }
        ]
      }
    }
  }
}
