#!/bin/bash

readonly DOCKER_IMAGE=${DOCKER_IMAGE:-'ubi8-ansible'}
readonly DOCKER_NAME=${1:-'demo'}

if [ ! "$(docker ps -q -f name=${DOCKER_NAME})" ]; then
  podman run  -dit --systemd=true --privileged=true  \
       --rm --name "${DOCKER_NAME}" --workdir /work -v $(pwd):/work:rw \
       "${DOCKER_IMAGE}" \
       /sbin/init
fi
podman exec -ti "${DOCKER_NAME}" /bin/bash

