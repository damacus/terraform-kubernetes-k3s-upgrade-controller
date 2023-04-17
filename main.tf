variable "upgrade_controller_version" {
  type    = string
  default = "v0.10.0"
  description = "The version of the system-upgrade-controller to use."
}

variable "kubectl_version" {
  type    = string
  default = "1.21.9"
  description = "The version of kubectl to use."
}

variable "k3s_channel" {
  type    = string
  default = "stable"
  description = "The channel to use for k3s upgrades."
}
