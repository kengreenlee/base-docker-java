#!/bin/bash

apiKey="SxJNijk3_3QYWLfzeJIVNUKvgL2s9_JsROdN69ncsK1f"

echo ${apiKey} | docker login -u iamapikey --password-stdin us.icr.io

# push Docker image to IBM Cloud CR
docker tag myjava:latest us.icr.io/fci-dev/myjava:latest
docker push us.icr.io/fci-dev/myjava:latest
