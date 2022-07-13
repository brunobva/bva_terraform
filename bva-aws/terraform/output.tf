output "bvaInstancePubIP" {
  value = aws_instance.bvadev001.public_ip
}
output "bvaInstancePubDNS" {
  value = aws_instance.bvadev001.public_dns
}
output "bvaInstancePrivIP" {
  value = aws_instance.bvadev001.private_ip
}