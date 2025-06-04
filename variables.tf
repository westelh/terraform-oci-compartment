variable "tenancy_ocid" {
  type = string
}

variable "compartment_ocid" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["Prod", "Pre-prod", "Staging", "Dev", "Test", "Trial", "Sandbox", "User Testing"], var.environment)
    error_message = "Valid values are Prod, Pre-prod, Staging, Dev, Test, Trial, Sandbox, User Testing"
  }
}

variable "value_is_required" {
  type    = bool
  default = false
}

variable "defined_tags" {
  type = map(string)
}

variable "freeform_tags" {
  type = map(string)
}
