import boto3
import urllib.request
import json

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
    print('enter lambda_handler')
    secrets=get_secret()
    print(type(secrets))
    
    url=secrets['url'] + secrets['color'] +'/' +secrets['color'] + '_tripdata_' + secrets['date_YYYY-MM'] + ".csv.gz"
    bucket = secrets['bucket']
    
    key = secrets['raw_data']+secrets['color']+'_tripdata_' + secrets['date_YYYY-MM'] + ".csv.gz"

    s3 = boto3.client('s3')
    urllib.request.urlretrieve(url, '/tmp/tempfile')
    s3.put_object(Bucket=bucket, Key=key, Body=open('/tmp/tempfile','rb'))
    print('end')
