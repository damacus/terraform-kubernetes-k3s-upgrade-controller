resource "kubernetes_manifest" "client_plan" {
  manifest = {
    apiVersion = "upgrade.cattle.io/v1"
    kind       = "Plan"

    metadata = {
      name      = "client-upgrade-plan"
      namespace = "system-upgrade"
      labels = {
        "k3s-upgrade" = "client"
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
            key      = "node-role.kubernetes.io/control-plane"
            operator = "DoesNotExist"
            values   = ["true"]
          }
        ]
      }

      prepare = {
        args  = ["prepare", kubernetes_manifest.system_upgrade.manifest.metadata.name]
        image = "rancher/k3s-upgrade"
      }
    }
  }
}
