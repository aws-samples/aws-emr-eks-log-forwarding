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
```


Be sure to:

* Change the title in this README
* Edit your repository description on GitHub

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

