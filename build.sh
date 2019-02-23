#!/usr/bin/env bash

PROGNAME=$(basename $0)
error_exit()
{
	  echo "${PROGNAME}: ${1:-"Unknown Error"}" 1>&2
	  exit 1
}

docker build --pull --tag kurron/docker-amazon-jdk-8-build:latest  . || error_exit "Unable to build image."

