provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  name       = "my-vpc"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "my-terraform-bucket-example"
}
module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  name              = "dev-subnet"
}

# Add EC2 after VPC and subnet exist
module "ec2" {
  source      = "./modules/ec2"
  ami         = "ami-abc123"
  instance_type = "t2.micro"
  subnet_id   = module.subnet.subnet_id  # <- Subnet must exist first
  name        = "web-server"
}