output "file1_path" {
  description = "value of file1_path"
  value       = local_file.file1.filename
  
}

output "file2_path" {
  description = "value of file2_path"
  value       = local_file.file2.filename
  
}