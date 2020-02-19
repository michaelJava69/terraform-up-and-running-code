terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

module "webserver_cluster" {

  # Since the terraform-up-and-running-code repo is open source, we're using an HTTPS URL here. If it was a private
  # repo, we'd instead use an SSH URL (git@github.com:brikis98/terraform-up-and-running-code.git) to leverage SSH auth
  
  # for 0.1
  # source = "github.com/brikis98/terraform-up-and-running-code//code/terraform/04-terraform-module/module-example/modules/services/webserver-cluster?ref=v0.1.0"

  # for 0.4 loops and expressions
  #source = "github.com/michaelJava69/terraform-up-and-running-code//code/terraform/09-terraform-michael/module-example/modules/services/webserver-cluster?ref=v0.4.0"
  
  # for 0.5 zero downtime
  source = "github.com/michaelJava69/terraform-up-and-running-code//code/terraform/09-terraform-michael/module-example/modules/services/webserver-cluster?ref=v0.5.2"

  ami         = "ami-0c55b159cbfafe1f0"

  server_text = var.server_text

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2

  # addtions for chapter 5 loops and expressions
  enable_autoscaling   = false
  enable_new_user_data = true

}

resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
