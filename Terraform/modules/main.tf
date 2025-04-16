terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

module "create_files" {
  source = "./file-creator"
  filename_1 = "my_first_file.txt"
  filename_2 = "my_second_file.txt"
  file1_content = "This is the content of file 1"
  file2_content = "This is the content of file 2"
}


output "file_paths"{
  value = [
    module.create_files.file1_path,
    module.create_files.file2_path,
  ]
  description = "Paths of the created files"
}