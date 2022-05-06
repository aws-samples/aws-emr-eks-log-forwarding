# name of our Amazon OpenSearch cluster
export ES_DOMAIN_NAME="emreksdemo"

# Elasticsearch version
export ES_VERSION="OpenSearch_1.0"

# OpenSearch Dashboards admin user
export ES_DOMAIN_USER="emreks"

# OpenSearch Dashboards admin password
export ES_DOMAIN_PASSWORD='< ADD YOUR PASSWORD >'


# Download and update the template using the variables created previously
curl -sS https://www.eksworkshop.com/intermediate/230_logging/deploy.files/es_domain.json \
  | envsubst > ~/temp/es_domain.json

# Create the cluster
aws opensearch create-domain \
  --cli-input-json  file://~/temp/es_domain.json --region us-east-1 --profile cloud9

