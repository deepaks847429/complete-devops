terraform{
  required_providers {
    local={
      source="hashicorp/local"
      version=" 2.5.1"
    }
  }
}

resource "local_file" "example1" {
  filename = "${path.module}/ ${var.filename-1}.txt"
  content  = "Hello, World!"
  count = var.count_num
  
}
resource "local_file" "example2" {
  filename = "${path.module}/ ${var.filename-2}.md"
  content  = "Hello, World!"
  
}
resource "local_file" "example3" {
  filename = "${path.module}/ ${var.filename-3}.demo"
  content  = "Hello, World!"
  
}