#! /bin/bash

sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user

# Option 1
sudo docker build -t node-container .
sudo docker run -d -p 3000:3000 node-container

# Option 2
sudo docker-compose up -d
