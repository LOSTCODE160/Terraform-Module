variable "env" {
  description = "this the env for my infra"
  type        = string

}

variable "bucket_name" {
  description = "this is for s3 bucket name"
  type        = string
}

variable "instance_count" {
  description = "number of instances to create"
  type        = number
}

variable "instance_type" {
  description = "type of instance to create"
  type        = string
}
variable "ec2_ami_id" {
  description = "ami id for ec2 instance"
  type        = string
}

variable "hash_key" {
  description = "hash key for dynamodb table"
  type        = string
}
