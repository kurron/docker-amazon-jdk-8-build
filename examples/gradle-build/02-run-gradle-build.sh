#!/bin/bash

# Some of these values are for illustration only and don't actually affect the build.
# The important concepts is that the source directory needs to be mounted into the
# container and that user/group ids must match yours or the generated files will be
# owned by the wrong account.

DOCKER_GROUP_ID=$(cut -d: -f3 < <(getent group docker))
USER_ID=$(id -u $(whoami))
GROUP_ID=$(id -g $(whoami))

CMD="docker run --cpus 1 \
                --group-add ${DOCKER_GROUP_ID} \
                --env HOME=/tmp \
                --interactive \
                --name gradle-build-example \
                --rm \
                --tty \
                --user=${USER_ID}:${GROUP_ID} \
                --volume /var/run/docker.sock:/var/run/docker.sock \
                --volume $(pwd)/spring-cloud-aws-echo:/spring-cloud-aws-echo \
                --workdir /spring-cloud-aws-echo \
                dockerazuljdk8build_azul-jdk:latest
                ./gradlew -PpublishArtifacts=true \
                          -PrunIntegrationTests=true \
                          -PpublishToDockerRegistry=true \
                          -PrunIntegrationTests=true \
                          -PrunAcceptanceTests=true \
                          -Dspring.profiles.active=stage-two \
                          -Dspring.data.mongodb.database=core-services-simulate-bamboo \
                          -Dspring.rabbitmq.virtual-host=/stage-two \
                          -Pmajor=0 \
                          -Pminor=0 \
                          -Ppatch=0 \
                          -Pbranch=master \
                          -PansiblePlaybookPath=/usr/bin/ansible-playbook \
                          --gradle-user-home=/tmp \
                          --project-dir=/spring-cloud-aws-echo \
                          --console=plain \
                          --no-daemon \
                          --no-search-upward \
                          --stacktrace"
echo $CMD
$CMD
