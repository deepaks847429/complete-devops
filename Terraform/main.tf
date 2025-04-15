# simple file resource

resource "local_file" "tf_example1" {
  #filename = "Terraform/example.txt"
  filename = "${path.module}/example-${count.index}.txt"
  content = "Hey, this is a test file created by Terraform, and i learnt it!"
  count=3
}

resource "local_sensitive_file" "tf_example2" {
  filename = "${path.module}/sensitive-${count.index}.txt"
  content = "this is a sensitive file created by Terraform, and i learnt it!"
  count = 3
  
  
}