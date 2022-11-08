output "sqs_queue" {
  description = "EKS cluster ID."
  value       = aws_sqs_queue.create_queue_sqs
}

output "sqs_queue_arn" {
  description = "EKS cluster ID."
  value       = aws_sqs_queue.create_queue_sqs.arn
}

output "sqs_queue_policy" {
  description = "Endpoint for EKS control plane."
  value       = aws_sqs_queue_policy.create_queue_sqs_policy
}
