.PHONY: app

env:
	export TAURUS_ARTIFACTS_VOLUME=/Users/David/Sites/blazemeter-demo/artifacts

network:
	docker network create blazemeter-demo || true

app:
	docker build \
	-f Dockerfile.app \
	-t blaze-app . \
	&& docker run \
	-p 8888:80 \
	--name=blaze-app \
	--network=blazemeter-demo \
	blaze-app

#replace absolute path below with your path
bzt:
	docker build \
	-f Dockerfile.taurus \
	-t bzt . \
	&& docker run \
	-v ${BZT_ARTIFACTS_VOLUME}:/tmp/artifacts/ \
	--network=blazemeter-demo \
	bzt \
	/bzt-configs/the-test.yml -report

jenkins:
	docker build \
	-f Dockerfile.jenkins \
	-t jenkins . \
	&& docker run \
	--name=jenkins \
	--publish 8080:8080 \
	--volume $(PWD)/jenkins_home:/var/jenkins_home \
	--volume /var/run/docker.sock:/var/run/docker.sock \
	--network=blazemeter-demo \
	jenkins
