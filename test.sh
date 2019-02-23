#!/bin/bash

# Any arguments provided to this script will be the command run inside the container.
# This to try:
#   * java -version
#   * docker info
#   * docker-compose --version
#   * ansible --version
#   * ansible all --inventory='localhost,' --connection=local -m ping

DOCKER_GROUP_ID=$(cut -d: -f3 < <(getent group docker))
USER_ID=$(id -u $(whoami))
GROUP_ID=$(id -g $(whoami))
HOME_DIR=$(cut -d: -f6 < <(getent passwd ${USER_ID}))

CMD="docker run --hostname inside-docker \
                --group-add ${DOCKER_GROUP_ID} \
                --env HOME=${HOME_DIR} \
                --env SSH_AUTH_SOCK=${SSH_AUTH_SOCK} \
                --interactive \
                --name zulu-build-test \
                --rm \
                --tty \
                --user=${USER_ID}:${GROUP_ID} \
                --volume ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} \
                --volume /var/run/docker.sock:/var/run/docker.sock \
                --volume $(pwd):$(pwd) \
                --volume ${HOME_DIR}:${HOME_DIR} \
                --volume /etc/passwd:/etc/passwd \
                --volume /etc/group:/etc/group \
                --workdir $(pwd) \
                docker-azul-jdk-8-build_azul-jdk:latest $*"
echo $CMD
$CMD
