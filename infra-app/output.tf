output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.this[*].public_ip
}
