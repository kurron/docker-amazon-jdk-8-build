#!/bin/bash

# use the time as a tag
UNIXTIME=$(date +%s)

# docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]
docker tag kurron/docker-amazon-jdk-8-build:latest kurron/docker-amazon-jdk-8-build:${UNIXTIME}
docker images

# Usage:  docker push [OPTIONS] NAME[:TAG]
docker push kurron/docker-amazon-jdk-8-build:latest
docker push kurron/docker-amazon-jdk-8-build:${UNIXTIME}
