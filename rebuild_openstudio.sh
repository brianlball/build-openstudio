#!/bin/bash -e

docker image rm build-openstudio -f
docker build . -t="build-openstudio"