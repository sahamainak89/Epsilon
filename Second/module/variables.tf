variable "instanceName" {
  description = "Instance Name"
  type = string
}

variable "serverCount" {
  default = ["01", "02", "03"]
}

variable "instanceCount" {
  default = 1
}

variable "env" {
  default = "Dev"
}
