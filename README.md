# Stream Amazon EMR on EKS logs to third-party providers 

## Introduction
This solution uses pod templates to create a sidecar container alongside the Spark job pods. The sidecar containers are able to access the logs contained in the Spark pods and forward these logs to the log aggregator. This approach allows the logs to be managed separately from the EKS cluster and uses a small amount of resources because the sidecar container is only launched during the lifetime of the Spark job.

## Create an AWS Cloud9 workspace and prepare the workspace

Once a Cloud9 workspace is created, run the following commands

```
sudo yum -y install git
cd ~ 
git clone https://github.com/aws-samples/aws-emr-eks-log-forwarding.git
cd aws-emr-eks-log-forwarding
cd emreks
bash prepare_cloud9.sh
```

## Install Amazon EKS and EMR on EKS

** Ensure that an EC2 key pair has been created **

After you configure the AWS Cloud9 workspace, in the same folder (emreks), run the following deployment script:

```
bash deploy_eks_cluster_bash.sh
```
You should get an output that looks like this and provide the information accordingly:
```
Deployment Script -- EMR on EKS
-----------------------------------------------

Please provide the following information before deployment:
1. Region (If your Cloud9 desktop is in the same region as your deployment, you can leave this blank)
2. Account ID (If your Cloud9 desktop is running in the same Account ID as where your deployment will be, you can leave this blank)
3. Name of the S3 bucket to be created for the EMR S3 storage location
Region: [xx-xxxx-x]: < Press enter for default or enter region > 
Account ID [xxxxxxxxxxxx]: < Press enter for default or enter account # > 
EC2 Public Key name: < Provide your key pair name here >
Default S3 bucket name for EMR on EKS (do not add s3://): < bucket name >
Bucket created: XXXXXXXXXXX ...
Deploying CloudFormation stack with the following parameters...
Region: xx-xxxx-x | Account ID: xxxxxxxxxxxx | S3 Bucket: XXXXXXXXXXX

...

EKS Cluster and Virtual EMR Cluster have been installed.
```

## Configure the Fluent Bit sidecar container
We need to write two configuration files to configure a Fluent Bit sidecar container. The first is the Fluent Bit configuration itself, and the second is the Fluent Bit sidecar subprocess configuration that makes sure that the sidecar operation ends when the main Spark job ends. The suggested configuration provided in the configuration file here is for Splunk and Amazon OpenSearch Service. However, you can configure Fluent Bit with other third-party log aggregators. For more information about configuring outputs, refer to [Outputs](https://docs.fluentbit.io/manual/pipeline/outputs).

### Fluent Bit ConfigMap

Modify the [emr_configmap.yaml](https://github.com/aws-samples/aws-emr-eks-log-forwarding/blob/main/kube/configmaps/emr_configmap.yaml) according to your environment. Do not make changes to [emr_entrypoint_configmap.yaml](https://github.com/aws-samples/aws-emr-eks-log-forwarding/blob/main/kube/configmaps/emr_entrypoint_configmap.yaml). Then run the following commands to add the configmaps:

```
kubectl apply -f emr_configmap.yaml
kubectl apply -f emr_entrypoint_configmap.yaml
```

## Prepare pod templates for Spark jobs
Copy the [two pod template yaml files](https://github.com/aws-samples/aws-emr-eks-log-forwarding/tree/main/kube/podtemplates) to an S3 location

## Submitting a Spark job with Fluent Bit sidecar container

```
cd emreks/scripts
bash run_emr_script.sh < S3 bucket name > < ECR container image > < script path>

Example: bash run_emr_script.sh emreksdemo-123456 12345678990.dkr.ecr.us-east-2.amazonaws.com/emr-6.5.0-custom s3://emreksdemo-123456/scripts/scriptname.py
```





## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

