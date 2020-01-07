terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

module "hello_world_app" {

  #source = "../../../../modules/services/hello-world-app"
  #source = "github.com/michaelJava69/terraform-up-and-running-code//code/terraform/09-terraform-michael/small-module/modules/services/hello-world-app?ref=v1.0.0"
   source = "github.com/michaelJava69/terraform-up-and-running-code//code/terraform/09-terraform-michael/production-module-example/small-modules/modules/services/hello-world-app?ref=v1.0.0"

  server_text = var.server_text

  environment            = var.environment
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type      = "t2.micro"
  min_size           = 2
  max_size           = 2
  enable_autoscaling = false
}
