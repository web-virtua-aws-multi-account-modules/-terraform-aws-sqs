resource "aws_sqs_queue" "create_queue_sqs" {
  name                              = var.queue_name
  name_prefix                       = var.name_prefix
  delay_seconds                     = var.delay_seconds
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.content_based_deduplication
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  kms_master_key_id                 = var.kms_master_key_id
  redrive_policy                    = var.redrive_policy
  redrive_allow_policy              = var.redrive_allow_policy
  kms_data_key_reuse_period_seconds = var.kms_reuse_period

  tags = merge(var.tags, {
    "tf-type" = "sqs"
    "tf-sqs"  = var.queue_name
    "tf-ou"   = var.ou_name
  })
}

resource "aws_sqs_queue_policy" "create_queue_sqs_policy" {
  count     = var.policy != {} ? 1 : 0
  queue_url = aws_sqs_queue.create_queue_sqs.id
  policy    = var.policy

  depends_on = [
    aws_sqs_queue.create_queue_sqs
  ]
}
