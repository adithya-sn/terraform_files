// AWS CONFIG
variable "region" {
  description = "Set AWS region for deployment"
}

//TF CONFIG
variable "domain_name" {
  description = "Domain name for the ES cluster"
}

//Set ES Version
variable "es_version" {
  description = "Version of ES to deploy"
  default     = "6.8"
}

//VPC vars
variable "subnet_ids" {
  description = "Subnet IDs to deploy into"
  default     = ""
}

variable "security_group_ids" {
  description = "Security Group id to attach"
}

//EBS vars for data nodes
variable "ebs_size" {
  description = "EBS volume size"
  default     = 80
}

variable "ebs_type" {
  description = "EBS volume type"
  default     = "gp2"
}

variable "ebs_iops" {
  description = "IOPS for io1 volume type"
  default     = ""
}

//Instance vars
variable "master_instance_count" {
  description = "Number of master instances, 3/5"
  default     = 3
}

variable "master_instance_type" {
  description = " Type of master instances"
  default     = "t2.small.elasticsearch"
}

variable "data_instance_count" {
  description = "Number of data instances"
  default     = 2
}

variable "data_instance_type" {
  description = "Type of data instances"
  default     = "t2.small.elasticsearch"
}

//AZ awareness vars
variable "zone_awareness" {
  description = "Enable zone awareness"
  default     = "false"
}

variable "az_count" {
  description = "Number of AZs. 1/2/3"
  default     = 2
}

//Node to node encryption vars
variable "node_to_node_encryption" {
  description = "Enable node-to-node encryption"
  default     = "false"
}

//Logging
variable "index_slow_logs" {
  description = "Enable slow log indexing"
  default     = "false"
}

//Tags
variable "env" {
  description = "Environment"
  default     = "dev"
}

variable "appname" {
  description = "Application Name"
  default     = ""
}
