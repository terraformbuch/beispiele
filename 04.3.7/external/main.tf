data "external" "my_program" {
  program = ["python3", "${path.module}/script.py"]

  query = {
    id = "abc123"
  }
}

output "ausgabe" {
  value = data.external.my_program.result
}
