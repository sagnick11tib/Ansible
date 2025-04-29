variable "ec2_ami_id" {
  default = "ami-0e35ddab05955cf57"
  type    = string
}

variable "outbound_traffic_allowed" {
  description = "Allow outbound traffic"
  type        = bool
  default     = true
}

variable "allow_ssh" {
  description = "Allow SSH access"
  type        = bool
  default     = true
}

variable "allow_http" {
  description = "Allow HTTP access"
  type        = bool
  default     = true
}

variable "allow_nodeport" {
  description = "Allow NodePort access"
  type        = bool
  default     = true
}