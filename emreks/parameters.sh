### Parameters

########## Parameters (Start)

### VPC Parameters (start)
vpcstack="emr-eks-vpc" ## Name of the CloudFormation stack name for VPC creation
VpcCidr="172.20.0.0/16" ## CIDR for the VPC (new)
PrivateSubnet0Cidr="172.20.1.0/24" ## CIDR for the private subnet in first AZ
PrivateSubnet1Cidr="172.20.2.0/24" ## CIDR for the private subnet in second AZ
PublicSubnet0Cidr="172.20.3.0/24" ## CIDR for the public subnet in first AZ
PublicSubnet1Cidr="172.20.4.0/24" ## CIDR for the public subnet in second AZ

### VPC Parameters (end)

### EKS Cluster Parameters (start)
clustername="eks-emr-spark-cluster-demo" ## EKS Cluster Name
version="1.19" ## EKS Version -- Do not use Version 1.19 at this moment.
managedNodeName="spark-nodes" ## EKS Managed Node Name
instanceType="m5.xlarge" ## EC2 Instance Type
volumeSize="30" ## Volume Size of EC2 EBS Vol
desiredCapacity="6" ## Desired capacity
desiredCapacityFargate="1" ## Desired capacity for Fargate Deployment
maxPodsPerNode="10" ## Maximum number of Pods Per Node

### EKS Cluster Parameters (end)

### Virtual EMR Cluster Parameters (start)
namespace="sparkns"
virtclustername="virt-emr-cluster-demo" ## EKS Cluster Name
emr_release_label="emr-6.5.0-latest" ## EMR Release Label version
cf_virtclustername="cf-virt-emr-cluster"
### Virtual EMR Cluster Parameters (end)

### IAM Roles and policies (start)
cf_iam_s3bucket_policy="cf-iam-s3bucket-eks-policy"
cf_iam_stackname="emr-eks-iam-stack" # CloudFormation Stack Name for IAM roles for Job Execution
### IAM Roles and policies (end)

########## Parameters (End)
