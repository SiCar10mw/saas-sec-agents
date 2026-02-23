variable "name_prefix" {
  type        = string
  description = "Prefix for cloud MCP resources"
}

variable "location" {
  type        = string
  default     = "eastus2"
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
