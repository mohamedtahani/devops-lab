#!/bin/bash

set -e


sudo apt update -y
sudo apt upgrade -y


sudo apt install -y openjdk-17-jdk


curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null


sudo apt update -y
sudo apt install -y jenkins


sudo systemctl start jenkins
sudo systemctl enable jenkins





