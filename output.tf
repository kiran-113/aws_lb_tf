output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.my_alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the ALB (useful for DNS records)"
  value       = aws_lb.my_alb.zone_id
}
