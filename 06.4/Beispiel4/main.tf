locals {
  list_of_all_server_names = concat(
    aws_instance_webserver[*].name,
    aws_instance_database[*].name
  )
}
