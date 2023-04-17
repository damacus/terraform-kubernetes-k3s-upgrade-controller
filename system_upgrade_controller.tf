resource "kubernetes_namespace" "upgrade_controller" {
  metadata {
    name = "system-upgrade"
  }
}

resource "kubernetes_service_account" "upgrade_controller" {
  metadata {
    name      = "system-upgrade"
    namespace = kubernetes_namespace.upgrade_controller.id
  }

  secret {
    name = kubernetes_secret_v1.upgrade_controller.id
  }
}

resource "kubernetes_secret_v1" "upgrade_controller" {
  metadata {
    name      = "system-upgrade-token"
    namespace = kubernetes_namespace.upgrade_controller.id
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_namespace.upgrade_controller.id
    }
  }

  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role_binding" "upgrade_controller" {
  metadata {
    name = "system-upgrade"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "system-upgrade"
    namespace = kubernetes_namespace.upgrade_controller.id
  }
}

resource "kubernetes_config_map" "upgrade_controller" {
  metadata {
    name      = "default-controller-env"
    namespace = kubernetes_namespace.upgrade_controller.id
  }

  data = {
    SYSTEM_UPGRADE_CONTROLLER_DEBUG             = "false"
    SYSTEM_UPGRADE_CONTROLLER_THREADS           = "2"
    SYSTEM_UPGRADE_JOB_ACTIVE_DEADLINE_SECONDS  = "900"
    SYSTEM_UPGRADE_JOB_BACKOFF_LIMIT            = "99"
    SYSTEM_UPGRADE_JOB_IMAGE_PULL_POLICY        = "Always"
    SYSTEM_UPGRADE_JOB_KUBECTL_IMAGE            = "rancher/kubectl:v${var.kubectl_version}"
    SYSTEM_UPGRADE_JOB_PRIVILEGED               = "true"
    SYSTEM_UPGRADE_JOB_TTL_SECONDS_AFTER_FINISH = "900"
    SYSTEM_UPGRADE_PLAN_POLLING_INTERVAL        = "15m"
  }
}

resource "kubernetes_deployment" "upgrade_controller" {
  metadata {
    name      = "system-upgrade-controller"
    namespace = kubernetes_namespace.upgrade_controller.metadata[0].name
  }

  spec {
    selector {
      match_labels = {
        "upgrade.cattle.io/controller" = "system-upgrade-controller"
      }
    }
    template {
      metadata {
        labels = {
          "upgrade.cattle.io/controller" = "system-upgrade-controller"
        }
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "node-role.kubernetes.io/master"
                  operator = "In"
                  values   = ["true"]
                }
              }
            }
          }
        }

        container {
          image             = "rancher/system-upgrade-controller:${var.upgrade_controller_version}"
          image_pull_policy = "Always"
          name              = "system-upgrade-controller"

          resources {
            requests = {
              cpu    = "1.0"
              memory = "500Mi"
            }
          }

          env {
            name = "SYSTEM_UPGRADE_CONTROLLER_NAME"
            value_from {
              field_ref {
                field_path = "metadata.labels['upgrade.cattle.io/controller']"
              }
            }
          }
          env {
            name = "SYSTEM_UPGRADE_CONTROLLER_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env_from {
            config_map_ref {
              name = "default-controller-env"
            }
          }

          volume_mount {
            mount_path = "/etc/ssl"
            name       = "etc-ssl"
          }

          volume_mount {
            mount_path = "tmp"
            name       = "tmp"
          }

          volume_mount {
            mount_path = "/etc/pki"
            name       = "etc-pki"
          }

          volume_mount {
            mount_path = "/etc/ca-certificates"
            name       = "etc-ca-certificates"
          }
        }

        service_account_name = kubernetes_service_account.upgrade_controller.metadata[0].name

        toleration {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }
        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/master"
          operator = "Exists"
        }
        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/controlplane"
          operator = "Exists"
        }
        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/control-plane"
          operator = "Exists"
        }
        toleration {
          effect   = "NoSchedule"
          key      = "node-role.kubernetes.io/etcd"
          operator = "Exists"
        }
        volume {
          name = "etc-ssl"
          host_path {
            path = "/etc/ssl"
            type = "Directory"
          }
        }
        volume {
          name = "tmp"
          empty_dir {}
        }
        volume {
          name = "etc-pki"
          host_path {
            path = "/etc/pki"
            type = "DirectoryOrCreate"
          }
        }
        volume {
          name = "etc-ca-certificates"
          host_path {
            path = "/etc/ca-certificates"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}
