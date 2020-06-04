variable "role" {
  description = "Name of Role"
  type        = string
  default     = null
}


variable "iam_policy_arns" {
  description = "List of IAM policy ARNs."
  type        = list
  default     = []
}

