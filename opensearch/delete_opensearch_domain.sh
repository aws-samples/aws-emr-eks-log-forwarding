# Set the domain name
domain="< DOMAIN NAME >"

# Set the region
region="< AWS REGION >"

# Delete the Opensearch Domain
aws opensearch delete-domain --domain-name ${domain} --region ${region}
