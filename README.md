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

Be sure to:

* Change the title in this README
* Edit your repository description on GitHub

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

