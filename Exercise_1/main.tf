# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "AKIA5WFHDELO6YPLALUA"
  secret_key = "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"
  region = "us-east-1"
}

# TODO: provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "UdacityT2" {
  count = "4"
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  tags = {
    name = "Udacity T2"
  }
}

# TODO: provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "UdacityM4" {
  count = "2"
  ami = "ami-0742b4e673072066f"
  instance_type = "m4.large"
  tags = {
    name = "Udacity M4"
  }
}