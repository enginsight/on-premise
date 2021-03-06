#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if ! type "docker" > /dev/null; then
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
fi

if ! type "docker-compose" > /dev/null; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o "/usr/bin/docker-compose"
  sudo chmod +x "/usr/bin/docker-compose"
fi

if ! type "git" > /dev/null; then
  sudo yum install -y git
fi

git clone https://github.com/enginsight/enterprise
cd enterprise

#clear
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin

#clear
chmod +x ./setup.sh && (cd .; source ./setup.sh docker)
