variable "name_prefix" {
  type        = string
  description = "Prefix for SIFT image factory resources"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus2"
}

variable "image_definition_name" {
  type        = string
  description = "Image definition name in Azure Compute Gallery"
  default     = "sift-ubuntu2204"
}

variable "replication_regions" {
  type        = list(string)
  description = "Regions to replicate the image version"
  default     = ["eastus2"]
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
