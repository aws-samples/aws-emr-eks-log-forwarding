if [ $# -ne 2 ];
  then 
    echo "There are insufficient parameters applied. Example: bash create_custom_image.sh us-east-1 755674844232"
    exit 1
fi

region=$1
registry=$2

sudo yum -y install docker
sudo systemctl start docker

echo "FROM ${registry}.dkr.ecr.${region}.amazonaws.com/spark/emr-6.5.0:latest
USER root
### Add customization commands here ####
RUN pip3 install --upgrade boto3 pandas numpy
USER hadoop:hadoop" > Dockerfile

repository_name="emr-6.5.0-custom"
repository=$(aws ecr create-repository --repository-name ${repository_name})
ecruri=$(echo $repository | jq .repository.repositoryUri | sed 's/"//g')
ecrhost=$(echo $ecruri | sed "s/\/${repository_name}//")

## Login to EMR image registry
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin ${registry}.dkr.ecr.${region}.amazonaws.com

## Build the image on the desktop
docker build -t "${ecruri}:latest" .

## Login to your ECR repository
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin ${ecrhost}

## Push Docker image to ECR
docker push ${ecrhost}/${repository_name}:latest
