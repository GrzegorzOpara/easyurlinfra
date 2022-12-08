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

variable "TF_STATE_RG" {
  description = "TF State Resource Group"
  type        = string
  sensitive   = true
}

variable "TF_STATE_SA" {
  description = "TF State Storage Account Name"
  type        = string
  sensitive   = true
}

variable "TF_STATE_CN" {
  description = "TF State Container Account Name"
  type        = string
  sensitive   = true
}

variable "TF_STATE_KEY" {
  description = "TF State tfstate key"
  type        = string
  sensitive   = true
}