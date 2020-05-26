#!/bin/bash

apiKey="SxJNijk3_3QYWLfzeJIVNUKvgL2s9_JsROdN69ncsK1f"

buildah push --tls-verify=false \
	--creds=iamapikey:${apiKey} \
	localhost/myjava:latest \
	docker://us.icr.io/fci-dev/myjava:latest
