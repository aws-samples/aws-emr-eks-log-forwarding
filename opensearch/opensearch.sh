# name of our Amazon OpenSearch cluster
export ES_DOMAIN_NAME="emreksdemo"

# Elasticsearch version
export ES_VERSION="OpenSearch_1.0"

# Instance Type
export INSTANCE_TYPE="t3.small.search"

# OpenSearch Dashboards admin user
export ES_DOMAIN_USER="emreks"

# OpenSearch Dashboards admin password
export ES_DOMAIN_PASSWORD='< ADD YOUR PASSWORD >'


# Download and update the template using the variables created previously
curl -sS https://raw.githubusercontent.com/aws-samples/aws-emr-eks-log-forwarding/main/opensearch/es_domain.json \
  | envsubst > ~/temp/es_domain.json

# Create the cluster
aws opensearch create-domain \
  --cli-input-json  file://~/temp/es_domain.json --region ${REGION}

