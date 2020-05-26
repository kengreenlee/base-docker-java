#!/bin/bash

apiKey=$1

echo ${apiKey} | docker login -u iamapikey --password-stdin us.icr.io

# push Docker image to IBM Cloud CR
docker tag myjava:latest us.icr.io/fci-dev/myjava:latest
docker push us.icr.io/fci-dev/myjava:latest
