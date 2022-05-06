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

# Region
export REGION='< Set your region >'


# Update the template using the variables created previously
envsubst < es_domain.json > es_domain_values.json

# Create the cluster
aws opensearch create-domain \
  --cli-input-json  file://es_domain_values.json --region ${REGION}
  
