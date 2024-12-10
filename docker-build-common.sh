#!/usr/bin/echo Source this instead.
##
## Common docker build script
##
## EXPECTS Caller has set"
##  LLAMACPP_VER
##  DOCKERFILE
##  IMAGE 
##
set -euo pipefail


IMAGENAME=bbissell/${IMAGE}
MESSAGE="Building\t${IMAGE}\nfrom\t\tllamap.cpp rel $LLAMACPP_VER"

[ "$(which figlet)" ] && printf "${MESSAGE}" | expand -t 15,+8 | figlet -t
printf "\n${MESSAGE}\n\n"

pushd ./docker

docker build . \
    --file "${DOCKERFILE}" \
    --tag "${IMAGENAME}:${LLAMACPP_VER}" \
    --tag "${IMAGENAME}:latest" \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false

popd 

source ./cleanup-wsl-cache.sh