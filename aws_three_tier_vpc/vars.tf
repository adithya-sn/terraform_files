## Declare variables

## Global vars
variable "region" {
    default = "us-east-1"
    type = string
    description = "Region to setup the stack"
}

## VPC vars
variable "vpc_cidr" {
    default = "10.0.0.0/16"
    type = string
    description = "CIDR range of the VPC"
}