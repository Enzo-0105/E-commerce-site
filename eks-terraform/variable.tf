variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet" {
  type = map(object({
    az   = string
    cidr = string
  }))
  default = {
    subnet1 = {
      az   = "us-east-1a"
      cidr = "10.0.4.0/24"
    }
    subnet2 = {
      az   = "us-east-1b"
      cidr = "10.0.12.0/24"
    }

    subnet3 = {
      az   = "us-east-1c"
      cidr = "10.0.18.0/24"
    }
  }
}

variable "private_subnet" {
  type = map(object({
    az   = string
    cidr = string
  }))
  default = {
    p_subnet1 = {
      az   = "us-east-1a"
      cidr = "10.0.45.0/24"
    }
    p_subnet2 = {
      az   = "us-east-1b"
      cidr = "10.0.80.0/24"
    }
    p_subnet3 = {
      az   = "us-east-1c"
      cidr = "10.0.61.0/24"
    }
  }
}

variable "instance_types" {
  type    = list(string)
  default = ["t2.micro"]
}

variable "cluster-name" {
  type    = string
  default = "my-eks-cluster"
}

variable "desired_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "node_group_name" {
  type    = string
  default = "my-eks-node-group"
}
variable "s3" {
  type    = bool
  default = false
}

variable "bucket_name" {
  type    = string
  default = "my-s3-bucket"
}

variable "vpc-control" {
  type    = bool
  default = true
}