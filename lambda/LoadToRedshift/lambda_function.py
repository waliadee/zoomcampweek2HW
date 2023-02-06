import psycopg2

def lambda_handler(event context):
    conn_string = "postgresql://{}:{}@{}".format(
    'zoomcamp',
    'Admin123321',
    'my-sample-cluster.cvxrxoquybvb.us-east-1.redshift.amazonaws.com:5439/sample_db')
    conn = psycopg2.connect(conn_string)
    cur = conn.cursor()
    sql_query="select 1;"
    cur.execute(sql_query)
    conn.commit()
    cur.close()
    conn.close()