aws firehose create-delivery-stream \
  --delivery-stream-name < Name of Firehose Stream > \
  --delivery-stream-type DirectPut \
  --amazonopensearchservice-destination-configuration '{
      "RoleARN": "arn:aws:iam::< ACCOUNT NUMBER >:role/< IAM Role Name >",
      "DomainARN": "arn:aws:es:< REGION >:< ACCOUNT NUMBER >:domain/< Opensearch Domain Name >",
      "IndexName": "< Preferred Index Name>",
      "S3Configuration": {
          "RoleARN": "arn:aws:iam::< ACCOUNT NUMBER >:role/< IAM Role Name>",
          "BucketARN": "arn:aws:s3:::< S3 Bucket Name >",
          "Prefix": "< S3 output prefix >",
          "ErrorOutputPrefix":"< S3 output prefix for errors >"
      }
   }' \
  --region < region >
