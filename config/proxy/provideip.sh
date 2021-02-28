#!/bin/bash
az container list | jq -r '.[].ipAddress.ip' >> ipaddressnginx.txt
curl https://raw.githubusercontent.com/dewa55/inpure/main/config/proxyconf.conf > default.conf
curl 
myvar="$(cat ipaddressnginx.txt)"
sed -i "s/changeme/$myvar/g" default.conf
$DOCKER_PASS="mypass"
echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin
docker build . -t webproxy
docker push