# Make sure that you are in the same folder as ../aws-emr-eks-log-forwarding/emreks

# Set the region
region="< AWS REGION >"
source ./parameters.sh

# Delete EMR Virtual Cluster
aws cloudformation delete-stack \
  --stack-name ${cf_virtclustername} \
  --region ${region}

# Delete IAM Role for job execution
aws cloudformation delete-stack \
  --stack-name ${cf_iam_stackname} \
  --region ${region}

# Delete EKS Cluster
cluster=$(eksctl get cluster --region ${region} -o json|jq .[] | jq .Name | sed 's/"//g')
eksctl delete cluster --name ${cluster} --region ${region}

# Delete VPC
aws cloudformation delete-stack \
  --stack-name ${vpcstack} \
  --region ${region}

# Delete S3 bucket IAM policy
aws cloudformation delete-stack \
  --stack-name ${cf_iam_s3bucket_policy} \
  --region ${region}
