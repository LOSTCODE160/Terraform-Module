module "dev-infra" {
  source         = "./infra-app"
  env            = "dev"
  bucket_name    = "infra-s3-bucket"
  instance_count = 1
  instance_type  = "t3.micro"
  ec2_ami_id     = "ami-091138d0f0d41ff90"
  hash_key       = "student_id"
}

module "prod-infra" {
  source         = "./infra-app"
  env            = "prod"
  bucket_name    = "infra-s3-bucket"
  instance_count = 2
  instance_type  = "t3.micro"
  ec2_ami_id     = "ami-091138d0f0d41ff90"
  hash_key       = "student_id"
}

module "stg-infra" {
  source         = "./infra-app"
  env            = "stg"
  bucket_name    = "infra-s3-bucket"
  instance_count = 1
  instance_type  = "t3.small"
  ec2_ami_id     = "ami-091138d0f0d41ff90"
  hash_key       = "student_id"
}

