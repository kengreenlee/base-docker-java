#!/bin/bash

apiKey=$1

buildah push --tls-verify=false \
	--creds=iamapikey:${apiKey} \
	localhost/myjava:latest \
	docker://us.icr.io/fci-dev/myjava:latest
