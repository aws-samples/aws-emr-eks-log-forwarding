#Modify this stack name as necessary
splunk_stackname = "< Splunk Stack Name >"

# Modify this region as necessary
region = "< REGION >"

aws cloudformation delete-stack \
  --stack-name ${splunk_stackname} \
  --region ${region}
