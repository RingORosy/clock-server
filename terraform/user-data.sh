#!/bin/bash
set -eux   # apstājies pie pirmās kļūdas

# 1) Docker instalēšana AL2023
yum update -y
yum install -y docker          # ← pareizi AL2023
systemctl enable --now docker  # start + auto-start

# 2) Izvēlies publisko attēlu — piemērs ar nginxdemos/hello
IMG="nginxdemos/hello:latest"  # brīvi vari ielikt citu image
CTR_PORT=80                    # hello klausās 80
HOST_PORT=80                   # uz āru lietosim 80

# 3) Palaid konteineru
docker run -d --name clock \
  --restart unless-stopped \
  -p ${HOST_PORT}:${CTR_PORT} \
  "${IMG}"

