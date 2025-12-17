
region            = "ap-south-1"
my_ip_cidr        = "YOUR.PUBLIC.IP.ADDRESS/32"   # e.g., "49.36.x.x/32"
allow_http_cidr   = "0.0.0.0/0"                   # or restrict as needed
key_name          = "your-existing-keypair-name"  # must exist in AWS
instance_type     = "t3.micro"
vpc_cidr          = "10.0.0.0/16"
ami_id = "ami-068c0051b15cdb816"
#public_subnet_c
