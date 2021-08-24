output "acm_certificate_id" {
  description = "The ACM certificate ID"
  value       = aws_acm_certificate.certificate.id
}

output "acm_certificate_arn" {
  description = "The ACM certificate ARN"
  value       = aws_acm_certificate.certificate.arn
}
