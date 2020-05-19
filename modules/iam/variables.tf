variable "service_names" {
  description = "service names to role"
  type        = list(string)
  default     = null
}

variable "name" {
  description = "The name of the role."
  type        = string
  default     = null
}

variable "service_ids" {
  description = "List of identifiers for principals. e.g. ec2.amazonaws.com."
  type        = list(string)
}

variable "policy_arns" {
  description = "List of IAM policy ARNs."
  type        = list(string)
  default     = []
}

variable "path" {
  description = "The path to the role."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the role."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of tags for the IAM role."
  type        = map(string)
  default     = {}
}