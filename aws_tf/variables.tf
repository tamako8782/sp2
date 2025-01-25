variable "db_name" {
  type    = string
  default = "db-server-01"
}

variable "db_username" {
  type      = string
  sensitive = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "db_port" {
  type    = string
  default = "3306"
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "pgp_key" {
  type    = string

}
