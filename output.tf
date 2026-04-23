# EC2 PUBLIC IP
output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

# RDS ENDPOINT
output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

# DATABASE NAME
output "db_name" {
  value = aws_db_instance.db.db_name
}

# DATABASE USERNAME
output "db_username" {
  value = aws_db_instance.db.username
}

# DATABASE PASSWORD (sensitive)
output "db_password" {
  value     = aws_db_instance.db.password
  sensitive = true
}

