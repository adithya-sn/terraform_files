//Set region for deployment
region = ""

//Domain name for the ES cluster
domain_name =""

//Set version of ES
es_version = "7.1"

//VPC Vars
subnet_ids         = []
security_group_ids = []

//EBS Vars
ebs_size = 10
ebs_type = "gp2"
ebs_iops = 0

//AZ Awareness Vars
zone_awareness = "true"
az_count       = 2 //Takes 1,2,3

//Instance Vars
master_instance_type  = "t2.small.elasticsearch"
master_instance_count = 3 //Takes 3 or 5

data_instance_type  = "t2.small.elasticsearch"
data_instance_count = 2

//Node to node encryption
node_to_node_encryption = "false"

//Logging
index_slow_logs = "true"

//Tags
env     = "dev"
appname = "test"
