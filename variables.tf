variable "name" {
  type        = string
  default     = "imperva-dsf-dra-analytics"
  description = "Name to identify all resources"
  validation {
    condition     = length(var.name) >= 3
    error_message = "Name must be at least 3 characters"
  }
  validation {
    condition     = can(regex("^\\p{L}.*", var.name))
    error_message = "Must start with a letter"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "admin_registration_password" {
  type        = string
  description = "Password to be used to register Analytics Server to Admin Server"

  validation {
    condition     = length(var.admin_registration_password) >= 7
    error_message = "Password must be at least 7 characters long"
  }

  validation {
    condition     = can(regex("[A-Z]", var.admin_registration_password))
    error_message = "Password must contain at least one uppercase letter"
  }

  validation {
    condition     = can(regex("[a-z]", var.admin_registration_password))
    error_message = "Password must contain at least one lowercase letter"
  }

  validation {
    condition     = can(regex("\\d", var.admin_registration_password))
    error_message = "Password must contain at least one digit"
  }

  validation {
    condition     = can(regex("[*+=#%^:/~.,\\[\\]_]", var.admin_registration_password))
    error_message = "Password must contain at least one of the following special characters: *+=#%^:/~.,[]_"
  }
}

variable "analytics_ssh_password" {
  type        = string
  description = "Password to be used to ssh to the Analytics Server"

  validation {
    condition     = length(var.analytics_ssh_password) >= 7
    error_message = "Password must be at least 7 characters long"
  }

  validation {
    condition     = can(regex("[A-Z]", var.analytics_ssh_password))
    error_message = "Password must contain at least one uppercase letter"
  }

  validation {
    condition     = can(regex("[a-z]", var.analytics_ssh_password))
    error_message = "Password must contain at least one lowercase letter"
  }

  validation {
    condition     = can(regex("\\d", var.analytics_ssh_password))
    error_message = "Password must contain at least one digit"
  }

  validation {
    condition     = can(regex("[*+=#%^:/~.,\\[\\]_]", var.analytics_ssh_password))
    error_message = "Password must contain at least one of the following special characters: *+=#%^:/~.,[]_"
  }
}

variable "archiver_user" {
  type        = string
  default     = "archiver-user"
  description = "User to be used to upload archive files for the Analytics server"
}

variable "dra_version" {
  type        = string
  default     = "4.17"
  description = "The DRA version to install. Supported versions are 4.11.0.10.0.7 and up. Full version format is supported, for example, 4.11.0.10.0.7."
  nullable    = false
  validation {
    condition     = !startswith(var.dra_version, "4.10.") && !startswith(var.dra_version, "4.9.") && !startswith(var.dra_version, "4.8.") && !startswith(var.dra_version, "4.3.") && !startswith(var.dra_version, "4.2.") && !startswith(var.dra_version, "4.1.")
    error_message = "The dra_version value must be 4.11.0.10 or higher"
  }
}

variable "admin_server_private_ip" {
  type        = string
  description = "Private IP of the Admin Server"
}

variable "admin_server_public_ip" {
  type        = string
  description = "Public IP of the Admin Server"
}

variable "instance_type" {
  type        = string
  default     = "m5.xlarge"
  description = "EC2 instance type for the Analytics Server"
}

variable "key_pair" {
  type        = string
  description = "key pair"
}

variable "archiver_password" {
  type        = string
  description = "Password to be used to upload archive files for analysis"
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for the Analytics Server"
  validation {
    condition     = length(var.subnet_id) >= 15 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "Subnet id is invalid. Must be subnet-********"
  }
}

variable "security_group_ids" {
  type        = list(string)
  description = "AWS security group Ids to attach to the instance. If provided, no security groups are created and all allowed_*_cidrs variables are ignored."
  validation {
    condition     = alltrue([for item in var.security_group_ids : substr(item, 0, 3) == "sg-"])
    error_message = "One or more of the security group Ids list is invalid. Each item should be in the format of 'sg-xx..xxx'"
  }
  default = []
}

variable "allowed_admin_cidrs" {
  type        = list(string)
  description = "List of ingress CIDR patterns allowing the Admin Server to access the Analytics Server instance"
  validation {
    condition     = alltrue([for item in var.allowed_admin_cidrs : can(cidrnetmask(item))])
    error_message = "Each item of this list must be in a valid CIDR block format. For example: [\"10.106.108.0/25\"]"
  }
  default = []
}

variable "allowed_hub_cidrs" {
  type        = list(string)
  description = "List of ingress CIDR patterns allowing hub access"
  validation {
    condition     = alltrue([for item in var.allowed_hub_cidrs : can(cidrnetmask(item))])
    error_message = "Each item of this list must be in a valid CIDR block format. For example: [\"10.106.108.0/25\"]"
  }
  default = []
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  description = "List of ingress CIDR patterns allowing ssh access"
  validation {
    condition     = alltrue([for item in var.allowed_ssh_cidrs : can(cidrnetmask(item))])
    error_message = "Each item of this list must be in a valid CIDR block format. For example: [\"10.106.108.0/25\"]"
  }
  default = []
}

variable "allowed_agent_gateways_cidrs" {
  type        = list(string)
  description = "List of ingress CIDR patterns allowing agent gateway access for legacy deployment"
  validation {
    condition     = alltrue([for item in var.allowed_agent_gateways_cidrs : can(cidrnetmask(item))])
    error_message = "Each item of this list must be in a valid CIDR block format. For example: [\"10.106.108.0/25\"]"
  }
  default = []
}

variable "allowed_all_cidrs" {
  type        = list(string)
  description = "List of ingress CIDR patterns allowing access to all relevant protocols (E.g vpc cidr range)"
  validation {
    condition     = alltrue([for item in var.allowed_all_cidrs : can(cidrnetmask(item))])
    error_message = "Each item of this list must be in a valid CIDR block format. For example: [\"10.106.108.0/25\"]"
  }
  default = []
}

variable "ebs" {
  type = object({
    volume_size = number
    volume_type = string
  })
  description = "Compute instance volume attributes for the DRA Analytics"
  default = {
    volume_size = 1010
    volume_type = "gp3"
  }
}

variable "instance_profile_name" {
  type        = string
  default     = null
  description = "Instance profile to assign to the instance. Keep empty if you wish to create a new IAM role and profile"
}

variable "send_usage_statistics" {
  type        = bool
  default     = true
  description = "Set to true to send usage statistics."
}
