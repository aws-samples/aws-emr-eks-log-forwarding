if [ $# -ne 3 ];
  then 
    echo "There are insufficient parameters applied. Format: bash run_emr_script.sh <bucket name> <container image repository URI> <Script Path>"
    echo "NOTE: Script Path. Please include protocol. Example: If script is in S3: it should be s3://<bucket name>/<prefix>"
    echo "bash run_emr_script.sh emreksdemo-123456 12345678990.dkr.ecr.us-east-2.amazonaws.com/emr-6.5.0-custom s3://emreksdemo-123456/scripts/scriptname.py"
    exit 1
fi

source ../parameters.sh

region=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)

EMR_EKS_CLUSTER_ID=$(aws cloudformation describe-stack-resource --stack-name "${cf_virtclustername}" --region ${region} --logical-resource-id "EMRVirtualCluster" | jq .StackResourceDetail.PhysicalResourceId | sed 's/"//g')


IAMROLE=$(aws cloudformation describe-stack-resource --stack-name "${cf_iam_stackname}" --region ${region} --logical-resource-id "JobExecutionRole" | jq .StackResourceDetail.PhysicalResourceId | sed 's/"//g')

EMR_EKS_EXECUTION_ARN=$(aws iam get-role --role-name $IAMROLE --region ${region} | jq .Role.Arn | sed 's/"//g')


EMR_RELEASE=emr-6.5.0-latest
S3_BUCKET=$1
S3_FOLDER=logforward
CONTAINER_IMAGE=$2
SCRIPT_PATH=$3
APP_NAME="emreksdemo"

aws s3 cp ../../kube/podtemplates/emr_driver_template.yaml s3://${S3_BUCKET}/${S3_FOLDER}/podtemplates/
aws s3 cp ../../kube/podtemplates/emr_executor_template.yaml s3://${S3_BUCKET}/${S3_FOLDER}/podtemplates/


aws emr-containers start-job-run \
--virtual-cluster-id ${EMR_EKS_CLUSTER_ID} \
--name emreksdemo-job \
--execution-role-arn ${EMR_EKS_EXECUTION_ARN} \
--release-label ${EMR_RELEASE} \
--region ${region} \
--job-driver "{
    \"sparkSubmitJobDriver\": {
        \"entryPoint\": \"${SCRIPT_PATH}\",
        \"entryPointArguments\": [\"${APP_NAME}\", \"${S3_BUCKET}\",\"${S3_FOLDER}\"],
        \"sparkSubmitParameters\": \"--conf spark.executor.instances=1 --conf spark.executor.memory=4G --conf spark.executor.cores=2 --conf spark.driver.cores=1\"
        }
    }" \
--configuration-overrides "{
    \"applicationConfiguration\": [
      {
        \"classification\": \"spark-defaults\", 
        \"properties\": {
          \"spark.driver.memory\":\"2G\",
          \"spark.kubernetes.driver.podTemplateFile\":\"s3://${S3_BUCKET}/${S3_FOLDER}/podtemplates/emr_driver_template.yaml\",
          \"spark.kubernetes.executor.podTemplateFile\":\"s3://${S3_BUCKET}/${S3_FOLDER}/podtemplates/emr_executor_template.yaml\",
          \"spark.kubernetes.container.image\": \"${CONTAINER_IMAGE}\"
         }
      }
    ],
    \"monitoringConfiguration\": {
      \"s3MonitoringConfiguration\": {
        \"logUri\": \"s3://${S3_BUCKET}/${S3_FOLDER}/logs/spark/\"
      }
    }   
}"
