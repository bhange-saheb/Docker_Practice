variable "aws_region" {
  default = "us-east-1"
}

##Already created VPC
variable "vpc-id" {
  default = "vpc-09b61772212f15e92"

}

##Already created subnets
variable "subnet_ids" {

  default = ["subnet-0474fb552e1f46009", "subnet-010600579170451d8", "subnet-07cd125f4479e085b"]
}


variable "key_name" {
  default = "xxxxxxx"
}

variable "key_path" {
  default = "C:/Users/Admin/Downloads/XXXXXX.pem"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami" {
  default = "ami-0ec10929233384c7f"
}

