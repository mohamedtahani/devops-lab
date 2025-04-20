#!/bin/bash

set -e

sudo apt update -y
sudo apt upgrade -y

sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

sudo docker pull sonarqube:latest

sudo docker run -d --name sonarqube \
  -p 9000:9000 \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  sonarqube:latest

