variable "pub_sub_1_cidr_block" {
  type        = string
  description = "The CIDR block for the specific subnet"
  default     = "10.0.1.0/24"
}

variable "pri_sub_1_cidr_block" {
  type        = string
  description = "The CIDR block for the specific subnet"
  default     = "10.0.3.0/24"
}

variable "internet_cidr_string" {
    default = "0.0.0.0/0"
}
