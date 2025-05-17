# Variables

variable "yc_token" {
  type        = string
  description = "Yandex Cloud API key"
  default     = "TOKEN_CHANGE_ME"
}

variable "yc_cloud_id" {
  type        = string
  description = "Yandex Cloud id"
  default     = "b1givfjnecaq6gsd91ml"
}

variable "yc_folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
  default     = "b1g7qh7t0i4sftogmaue"
}

variable "master" {
  default = 3  
}

variable "worker" {
  default = 1
}

variable "lb" {
  default = 1
}
