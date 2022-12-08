variable "ARM_CLIENT_ID" {
  description = "Azure SP name"
  type        = string
  sensitive   = true
}

variable "ARM_CLIENT_SECRET" {
  description = "SP Secret"
  type        = string
  sensitive   = true
}

variable "ARM_SUBSCRIPTION_ID" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "ARM_TENANT_ID" {
  description = "Azure Tenant ID"
  type        = string
  sensitive   = true
}