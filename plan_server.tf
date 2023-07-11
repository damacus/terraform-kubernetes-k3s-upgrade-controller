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
      channel            = "https://update.k3s.io/v1-release/channels/${var.k3s_channel}"
      serviceAccountName = "system-upgrade"

      concurrency = var.client_concurrency
      cordon      = true

      drain = {
        force            = var.force_drain
        deleteLocalData  = var.delete_local_data
        ignoreDaemonSets = var.ignore_daemonsets
      }

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
