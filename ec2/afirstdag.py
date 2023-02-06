from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.amazon.aws.operators.lambda_function import AwsLambdaInvokeFunctionOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2022, 1, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'ETLDemo',
    default_args=default_args,
    schedule_interval=None,
    catchup=False
)

lambda_1_task = AwsLambdaInvokeFunctionOperator(
    task_id='run_lambda_1',
    aws_conn_id='aws_default',
    function_name='download',
    dag=dag
)

lambda_2_task = AwsLambdaInvokeFunctionOperator(
    task_id='run_lambda_2',
    aws_conn_id='aws_default',
    function_name='unzip',
    dag=dag
)

lambda_3_task = AwsLambdaInvokeFunctionOperator(
    task_id='run_lambda_3',
    aws_conn_id='aws_default',
    function_name='LoadToRedshift',
    dag=dag
)

lambda_1_task >> lambda_2_task >> lambda_3_task