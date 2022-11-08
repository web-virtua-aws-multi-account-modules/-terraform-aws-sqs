# AWS SQS queues for multiples accounts and regions Terraform module
* This module simplifies creating and configuring SQS queues across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

* OBS: FIFO type queues have a required name pattern, can be up to 80 characters and contain only letters, numbers, dashes and underscores, it is also mandatory to put ".fifo" at the end of the queue name, ex: tf-queue.fifo

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of S3 bucket configurations for this module:

- Standard and FIFO Queues
- Managed SSE Encription
- KMS Encription
- Policy
- Redrive Policy
- Redrive Enable Policy
- Queue custom Configuration

## Usage exemples


### Standard queue with policy

```hcl
module "queue_test_standard" {
  source     = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name = "tf-queue-test"
  policy     = var.policy

  providers = {
    aws = aws.alias_profile_a
  }
}
```

### Standard queue with managed SSE encription

```hcl
module "queue_test_sse" {
  source                  = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name              = "tf-queue-test-sse"
  sqs_managed_sse_enabled = true

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### FIFO queue

```hcl
module "queue_test_fifo" {
  source      = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name  = "tf-queue.fifo"
  fifo_queue  = true

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### FIFO queue with KMS encription

```hcl
module "queue_test_fifo" {
  source                            = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name                        = "tf-queue.fifo"
  fifo_queue                        = true
  kms_master_key_id                 = "alias/aws/sqs"
  kms_data_key_reuse_period_seconds = true

  providers = {
    aws = aws.alias_profile_b
  }
}
```

### Standard queue with redrive policy

```hcl
module "queue_test_standard" {
  source     = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name = "tf-queue-test"
  
  redrive_policy = jsonencode({
    deadLetterTargetArn = module.queue_test_standard.sqs_queue_arn
    maxReceiveCount     = 4
  })

  providers = {
    aws = aws.alias_profile_a
  }
}
```

### Standard queue with redrive allow policy

```hcl
module "queue_test_standard" {
  source     = "web-virtua-aws-multi-account-modules/sqs/aws"
  queue_name = "tf-queue-test"

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [module.queue_test_standard.sqs_queue_arn]
  })

  providers = {
    aws = aws.alias_profile_a
  }
}
```

## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| queue_name | `string` | `-` | yes | Name to queue | `-` |
| name_prefix | `string` | `null` | no | Name prefix to queue | `-` |
| delay_seconds | `number` | `90` | no | Delay for queue | `-` |
| max_message_size | `number` | `2048` | no | Max message size to queue | `-` |
| message_retention_seconds | `number` | `86400` | no | Message retention seconds | `-` |
| receive_wait_time_seconds | `number` | `86400` | no | Receive wait time seconds seconds | `-` |
| fifo_queue | `bool` | `false` | no | If is FIFO queue | `*`false <br> `*`true  |
| content_based_deduplication | `bool` | `false` | no | Content based deduplication | `*`false <br> `*`true  |
| sqs_managed_sse_enabled | `bool` | `false` | no | Enable SSE on queue | `*`false <br> `*`true  |
| kms_master_key_id | `string` | `null` | no | KMS master key ID | `-` |
| kms_reuse_period | `number` | `null` | no | KMS data key reuse period seconds | `-` |
| ou_name | `string` | `no` | no | Organization Unit | `-` |
| tags | `map(any)` | `{}` | no | Tags to bucket | `-` |
| policy | `any` | `{}` | no | Queue policy | `-` |
| redrive_policy | `any` | `null` | no | Redrive police | `-` |
| redrive_allow_policy | `any` | `null` | no | Allow redrive police | `-` |

## Resources

| Name | Type |
|------|------|
| [aws_sqs_queue.create_queue_sqs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [aws_sqs_queue_policy.create_queue_sqs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue_policy) | resource |


## Outputs

| Name | Description |
|------|-------------|
| `sqs_queue` | All informations of the queue |
| `sqs_queue_arn` | The ARN of the queue |
| `sqs_queue_policy` | The policy of the queue |
