#!/usr/bin/echo Source this instead.
##
## Common docker build script
##
## EXPECTS Caller has set"
##  LLAMA_CPP_VERSION
##  DOCKERFILE
##  IMAGE 
##
set -euo pipefail

# Import misc bash tools
source ./docker/src/stdbash.sh

# Expectations
[ -z "${DOCKERFILE:-}" ]    && stdbash::error "DOCKERFILE variable must contain the name dockerfile definition to build from"
[ -z "${IMAGENAME:-}" ]     && stdbash::error "IMAGENAME variable must contain the full container image name (repo/name)"
[ -z "${LLAMA_CPP_VERSION:-}" ]  && stdbash::error "LLAMA_CPP_VERSION variable must contain release tag"

# 
# IMAGENAME="thebiss/${IMAGE}"
MESSAGE="Building\t${IMAGENAME}\nfrom\t\tllamap.cpp rel $LLAMA_CPP_VERSION"

[ "$(which figlet)" ] && printf "${MESSAGE}" | expand -t 15,+8 | figlet -t
printf "\n${MESSAGE}\n\n"

pushd ./docker

docker build . \
    --file "${DOCKERFILE}" \
    --tag "${IMAGENAME}:${LLAMA_CPP_VERSION}" \
    --tag "${IMAGENAME}:latest" \
    --build-arg LLAMA_CPP_VERSION_TAG=${LLAMA_CPP_VERSION} \
    --rm=false

popd 

source ./cleanup-wsl-cache.sh