variable "ARM_CLIENT_ID" {
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  type        = string
  sensitive   = true
}

variable "ARM_SUBSCRIPTION_ID" {
  type        = string
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  type        = string
  sensitive   = true
}

variable "location" {
  type        = string
  default     = "North Europe"
}

variable "project_name" {
  type        = string
  default     = "easyurl"
}

variable "python_version" {
  type  = string
  default     = "3.9"
}