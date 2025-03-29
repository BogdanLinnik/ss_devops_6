variable "MONGODB_ATLAS_ORGANIZATION_ID" {
  type        = string
}
variable "MONGODB_ATLAS_PUBLIC_KEY" {
  type        = string
}
variable "MONGODB_ATLAS_PRIVATE_KEY" {
  type        = string
  sensitive   = true
}

variable "DB_USER_NAME" {
  type        = string
}

variable "DB_USER_PASSWORD" {
  type        = string
  sensitive   = true
}
