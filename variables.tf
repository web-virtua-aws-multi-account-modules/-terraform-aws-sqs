variable "queue_name" {
  description = "Queue name"
  type        = string
}

variable "name_prefix" {
  description = "Prefix name"
  type        = string
  default     = null
}

variable "delay_seconds" {
  description = "Delay for queue"
  type        = number
  default     = 90
}

variable "max_message_size" {
  description = "Max size for messages"
  type        = number
  default     = 2048
}

variable "message_retention_seconds" {
  description = "Time of retentions to messages"
  type        = number
  default     = 86400
}

variable "receive_wait_time_seconds" {
  description = "Wait time toof receive"
  type        = number
  default     = 10
}

variable "fifo_queue" {
  description = "If queue is type fifo"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Content based deduplication"
  type        = bool
  default     = false
}

variable "sqs_managed_sse_enabled" {
  description = "Enable SSE on queue"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "KMS master key ID"
  type        = string
  default     = null
}

variable "kms_reuse_period" {
  description = "KMS data key reuse period seconds"
  type        = number
  default     = null
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "tags" {
  description = "Tags to bucket"
  type        = map(any)
  default     = {}
}

variable "policy" {
  description = "Queue policy"
  type        = any
  default     = {}
}

variable "redrive_policy" {
  description = "Redrive police"
  type        = any
  default     = null
}

variable "redrive_allow_policy" {
  description = "Allow redrive police"
  type        = any
  default     = null
}
