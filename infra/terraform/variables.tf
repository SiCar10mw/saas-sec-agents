variable "name_prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus2"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
