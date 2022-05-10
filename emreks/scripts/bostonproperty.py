#!/usr/bin/env python
import sys
from pyspark.sql import SparkSession
from pyspark import SparkContext
import pyspark.sql.functions as f
from pyspark.sql.functions import col,concat,lit
from pyspark.sql.functions import sum,avg,max,min,mean,count
import boto3
import time

print ("Number of arguments:", len(sys.argv), "arguments")
print ("Argument List:", str(sys.argv))

app_name = sys.argv[1]
bucket_name = sys.argv[2]
bucket_folder = sys.argv[3]

input_prefix = "data/boston-property-assessment-2021.csv"
output_prefix = "output/boston-property-aggregate/"

input_s3 = "s3://" + bucket_name + "/" + bucket_folder + "/" + input_prefix
output_s3 = "s3://" + bucket_name + "/" + bucket_folder + "/" + output_prefix

spark = SparkSession.builder.appName(app_name).getOrCreate()

print("S3 bucket: " + bucket_name)
print("Folder prefix: " + bucket_folder)
print("Folder to be deleted: " + bucket_folder + "/" + output_prefix)

s3 = boto3.resource('s3')
bucket = s3.Bucket(bucket_name)
delete_response = bucket.objects.filter(Prefix=bucket_folder + "/" + output_prefix).delete()

print(delete_response)

#df = spark.read.option("header",True).csv("s3://tanmatth-emr-2/fluentbit/data/boston-property-assessment-2021.csv")
df = spark.read.option("header",True).csv(input_s3)
df.printSchema()

df.createOrReplaceTempView("property")

sql_script = """select TOTAL_VALUE, ZIPCODE from property limit 100"""
spark.sql(sql_script).show(5)


df2 = df.withColumn('total_value_double', f.regexp_replace('TOTAL_VALUE', '[$,]', '').cast('double')).withColumn('zip', concat(lit('0'),col('ZIPCODE')))
df2.printSchema()


df2.select(col('LU_DESC'),col('BED_RMS'),col('TOTAL_VALUE'),col('total_value_double'),col('zip')).show(10,False)


df_agg = df2.groupBy('zip','LU_DESC').agg(avg('total_value_double').alias('avg_total_value'),min('total_value_double').alias('min_total_value'),max('total_value_double').alias('max_total_value')).orderBy('zip','LU_DESC')

df_agg.show(50,truncate=False)

#df_agg.write.mode('overwrite').parquet('s3://tanmatth-emr-2/fluentbit/output/boston-property-aggregate/')
df_agg.write.mode('overwrite').parquet(output_s3)
