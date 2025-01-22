variable "db_name" {
  type = string
  default = "db-server-01"
}

variable "db_username" {
  type = string
  sensitive = true
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "multi_az" {
  type = bool
  default = false
}