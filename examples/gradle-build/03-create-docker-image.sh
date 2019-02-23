#!/bin/bash

# This example assumes that the project has already been built
# and it is time to use Ansible to execute the proper
# Docker and Docker Compose commands to create and tag the container.

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
                --volume $(pwd)/playbook.yml:/spring-cloud-aws-echo/playbook.yml \
                --workdir /spring-cloud-aws-echo \
                dockerazuljdk8build_azul-jdk:latest \
                ansible-playbook --inventory='localhost,' --verbose --connection=local playbook.yml"
echo $CMD
$CMD
