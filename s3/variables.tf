variable "bucket_name_data" {
  description="zoomcamp data"
  type       =string
  default    ="tf3bucket-zoomcamp-data"
}

variable "bucket_name_dag" {
  description="zoomcamp dags"
  type       =string
  default    ="tf3bucket-zoomcamp-airflowdags"
}
