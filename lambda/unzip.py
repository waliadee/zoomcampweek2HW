import boto3
import gzip
import io
import os
import json

s3 = boto3.client("s3")

def get_secret():

    secret_name = "first_secret"
    region_name = "us-east-1"

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )
    get_secret_value_response = client.get_secret_value(SecretId=secret_name)
    secret = get_secret_value_response['SecretString']
    return(json.loads(secret))
    
    
def lambda_handler(event, context):
    secrets=get_secret()
    #url=secrets['url'] + secrets['color'] +'/' +secrets['color'] + '_tripdata_' + secrets['date_YYYY-MM'] + ".csv.gz"
    #print(url)
    bucket = secrets['bucket']
    ip_filename =secrets['raw_data']+secrets['color']+'_tripdata_' + secrets['date_YYYY-MM'] + ".csv.gz"
    op_filename =secrets['unzip_data']+ip_filename.split("/")[-1].replace(".gz", "")
    
    print(bucket)
    print(ip_filename)
    s3.download_file(bucket, ip_filename,  "/tmp/temp_file.gz")
    with gzip.open("/tmp/temp_file.gz", "rb") as f_in:
        file_content = f_in.read()
    s3.upload_fileobj(io.BytesIO(file_content), bucket, op_filename)
    
    os.remove("/tmp/temp_file.gz")