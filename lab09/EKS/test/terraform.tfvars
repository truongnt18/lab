ClusterName=pwb-nonprod
env=non-prod
region=ap-southeast-1
bucket=pwb-nonprod-terraform-state
dynamodb_table=pwb-nonprod-terraform-state-locks
vpc_id=vpc-0341e01396fe4ef28
subnet_ids=[subnet-00fb23156121dddd0, subnet-05b9ab1e904b42e82, subnet-0cf6e5371acda491b, subnet-0c84bbbfd74224340, subnet-02ac3b1954dcffa7d, subnet-0bc05c5b508250133]
private_subnet_ids=[subnet-02ac3b1954dcffa7d, subnet-05b9ab1e904b42e82, subnet-0bc05c5b508250133]
account_id=434493680947
key_pair=pwb-magento-admin
instance_types=c5.2xlarge
backend_key_state=../backend-locks/terraform.tfstate
profile=cg-pwb-dev
