output "jenkins_server_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "sonarqube_server_ip" {
  value = aws_instance.sonarqube_server.public_ip
}

output "kops_machine_ip" {
  value = aws_instance.kops_machine.public_ip
}
