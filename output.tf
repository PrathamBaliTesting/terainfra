output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "security_group_id" {
  description = "The ID of the allow SSH security group"
  value       = aws_security_group.http_access.id
}

output "nat_gateway_id" {
  description = "The ID of Nat Gateway"
  value = aws_nat_gateway.ngw.id
}

output "eip_id" {
  description = "ID of Elastic IP"
  value = aws_eip.eip.id
  
}

output "network_acl_id" {
  description = "ID of Netwrok ACL"
  value = aws_network_acl.nacls.id
  
}