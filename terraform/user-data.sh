#!/bin/bash

yum update -y
yum install -y docker
systemctl enable --now docker

IMG="nginxdemos/hello:latest"
CTR_PORT=80
HOST_PORT=80

docker run -d --name test \
  --restart unless-stopped \
  -p ${HOST_PORT}:${CTR_PORT} \
  "${IMG}"

