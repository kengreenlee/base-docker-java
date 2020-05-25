FROM registry.access.redhat.com/ubi7/ubi:latest

ENV PATH=/opt/openjdk/bin:$PATH \
	JAVA_HOME=/opt/openjdk \
	JAVA_TOOL_OPTIONS="-XX:+IgnoreUnrecognizedVMOptions -XX:+UseContainerSupport -XX:+IdleTuningCompactOnIdle -XX:+IdleTuningGcOnIdle"

RUN yum clean all \
	&& yum -y install ca-certificates curl hostname unzip vim \
	&& yum -y update \
	\
	&& curl -L https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u252-b09_openj9-0.20.0/OpenJDK8U-jre_x64_linux_openj9_8u252b09_openj9-0.20.0.tar.gz -o /tmp/openjdk.tar.gz \
	\
	&& tmpDir=$(mktemp -d) \
	&& tar xzf /tmp/openjdk.tar.gz -C ${tmpDir} \
	&& jdkDir=$(ls -1 ${tmpDir}) \
	&& mkdir -p /opt/openjdk \
	&& mv ${tmpDir}/${jdkDir}/* /opt/openjdk/ \
	&& rm -rf ${tmpDir} \
	&& sed -i -- 's/#networkaddress.cache.ttl=-1/networkaddress.cache.ttl=30/g' /opt/openjdk/lib/security/java.security \
	\
	&& yum -y remove unzip \
	&& yum clean all \
	&& rm -rf /var/cache/yum* \
	&& rm -rf /tmp/openjdk.tgz
