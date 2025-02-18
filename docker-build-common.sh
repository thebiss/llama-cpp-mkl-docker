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

# Import misc bash tools
source ./docker/src/stdbash.sh

# Expectations
[ -z "${DOCKERFILE:-}" ]    && stdbash::error "DOCKERFILE variable must contain the name dockerfile definition to build from"
[ -z "${IMAGENAME:-}" ]     && stdbash::error "IMAGENAME variable must contain the full container image name (repo/name)"
[ -z "${LLAMACPP_VER:-}" ]  && stdbash::error "LLAMACPP_VER variable must contain release tag"

# 
# IMAGENAME="thebiss/${IMAGE}"
MESSAGE="Building\t${IMAGENAME}\nfrom\t\tllamap.cpp rel $LLAMACPP_VER"

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