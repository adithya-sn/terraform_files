## Outputs

# VPC
output "vpc_id" {
  value = aws_vpc.main.id
}

# Subnets
output "web_subnets_id" {
  value = aws_subnet.WebSubnets[*].id
}

output "db_subnets_id" {
  value = aws_subnet.DBSubnets[*].id
}

output "backend_subnets_id" {
  value = aws_subnet.BackendSubnets[*].id
}

# SG
output "vpc_allow_all_sg_id" {
  value = aws_security_group.allow_all_within_vpc.id
}

output "ssh_only_sg_id" {
  value = aws_security_group.ssh_only.id
}

output "web_sg_id" {
  value = aws_security_group.web_access.id
}