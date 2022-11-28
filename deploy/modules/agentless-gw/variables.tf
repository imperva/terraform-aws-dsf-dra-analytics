variable "name" {
  type        = string
  default     = "imperva-dsf-agentless-gw"
  description = "Deployment name"
  validation {
    condition     = length(var.name) > 3
    error_message = "Deployment name must be at least 3 characters"
  }
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for the DSF agentless gw instance"
  validation {
    condition     = length(var.subnet_id) >= 15 && substr(var.subnet_id, 0, 7) == "subnet-"
    error_message = "Subnet id is invalid. Must be subnet-********"
  }
}

variable "public_ip" {
  type        = bool
  default     = false
  description = "Create public IP for the instance"
}

variable "instance_type" {
  type        = string
  default     = "r6i.xlarge"
  description = "Ec2 instance type for the DSF agentless gw"
}

variable "ebs_details" {
  type = object({
    disk_size        = number
    provisioned_iops = number
    throughput       = number
  })
  description = "Compute instance volume attributes"
}

variable "sg_ingress_cidr" {
  type        = list(any)
  description = "List of allowed ingress cidr patterns for the DSF agentless gw instance for ssh and internal protocols"
}

variable "key_pair" {
  type        = string
  description = "key pair for DSF agentless gw instance. This key must be generated by by the hub module and present on the local disk"
}

variable "installation_location" {
  type = object({
    s3_bucket = string
    s3_key    = string
  })
  description = "S3 DSF installation location"
  nullable    = false
}

variable "sonarw_public_key" {
  type        = string
  description = "SSH public key for sonarw user"
  nullable    = false
}

variable "sonarw_secret_name" {
  type        = string
  description = "Secret name for sonarw ssh key"
  nullable    = false
}

variable "proxy_address" {
  type        = string
  description = "Proxy address used for ssh"
  default     = null
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Admin password"
  validation {
    condition     = length(var.admin_password) > 8
    error_message = "Admin password must be at least 8 characters"
  }
  nullable = false
}

variable "ssh_key_pair_path" {
  type        = string
  description = "SSH key path"
  nullable    = false
}

variable "dsf_base_ami_name_tag" {
  type    = string
  default = null
}

variable "role_arn" {
  type        = string
  default     = null
  description = "IAM role to assign to DSF gw"
}

######################## Additional (optional) parameters ########################
# Use this param to specify any additional parameters for the initial setup, example syntax below
# variable "additional_install_parameters" { default = "--smtp-ssl --ignore-system-warnings" }
# https://sonargdocs.jsonar.com/4.5/en/sonar-setup.html#noninteractive-setup
variable "additional_install_parameters" {
  default = ""
}
