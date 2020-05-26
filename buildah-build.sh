#!/bin/bash

ctr=$(buildah from --pull registry.access.redhat.com/ubi7/ubi:latest)

buildah config --env PATH=/opt/openjdk/bin:$PATH \
	--env JAVA_HOME=/opt/openjdk \
	--env JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle" \
	${ctr}

buildah run ${ctr} -- yum clean all
buildah run ${ctr} -- yum -y install ca-certificates curl hostname unzip vim
buildah run ${ctr} -- yum -y update

buildah run ${ctr} -- curl -L https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09_openj9-0.20.0/OpenJDK8U-jre_x64_linux_openj9_8u252b09_openj9-0.20.0.tar.gz -o /tmp/openjdk.tar.gz

buildah run ${ctr} -- /bin/bash -c 'tmpDir=$(mktemp -d);
	tar xzf /tmp/openjdk.tar.gz -C ${tmpDir};
	jdkDir=$(ls -1 ${tmpDir});
	mkdir -p /opt/openjdk;
	mv ${tmpDir}/${jdkDir}/* /opt/openjdk/;
	rm -rf ${tmpDir}'

buildah run ${ctr} -- sed -i -- 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=30/g' /opt/openjdk/lib/security/java.security
buildah run ${ctr} -- yum -y remove unzip
buildah run ${ctr} -- yum clean all
buildah run ${ctr} -- rm -rf /var/cache/yum*
buildah run ${ctr} -- rm -rf /tmp/openjdk.tar.gz

buildah commit ${ctr} myjava:latest
