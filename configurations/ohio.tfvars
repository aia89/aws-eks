

subnets = [
    "subnet-07376f0fb9bfc3153", 
    "subnet-07237aa90a7fc24e9", 
    "subnet-07c4d6701568c199b"
    ]

vpc_id = "vpc-068c06c2fb84fa9a1"
instance_type = "m4.large"
asg_max_size = 5
region = "us-east-2"



#Mapping
tags = {
Env         = "Development"
Billing     = "SMA"
Application = "Artemis" 
Region      = "us-east-1"
Created_by  = "aia"
Team        = "DevOps"
Name        = "something"
Quarter     = 3
Managed_by  = "infrastructure"
}

# Below code is used to set backend only
environment                     =   "ohio"
s3_bucket                       =   "terraform-state-aipril-class-aia"
s3_folder_project               =   "eks"
s3_folder_region                =   "us-east-1"
s3_folder_type                  =   "tools"
s3_tfstate_file                 =   "eks.tfstate"


