variable "client_concurrency" {
  type        = number
  description = "Number of clients to upgrade at a time"
  default     = 1
}

variable "server_concurrency" {
  type        = number
  description = "Number of servers to upgrade at a time"
  default     = 1
}

variable "force_drain" {
  type        = bool
  description = "Force drain nodes"
  default     = true
}

variable "delete_local_data" {
  type        = bool
  description = "Delete local data"
  default     = false
}

variable "ignore_daemonsets" {
  type        = bool
  description = "Ignore daemonsets"
  default     = true
}

variable "upgrade_controller_version" {
  type        = string
  default     = "v0.11.0"
  description = "The version of the system-upgrade-controller to use."
}

variable "kubectl_version" {
  type        = string
  default     = "1.27.6"
  description = "The version of kubectl to use."
}

variable "k3s_channel" {
  type        = string
  default     = "stable"
  description = "The channel to use for k3s upgrades."
}
