#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}
DOCKERFILE=llama-server-vulkan.Dockerfile
IMAGE=llama-cpp-vulkan
IMAGENAME=bbissell/${IMAGE}
MESSAGE="Building\t${IMAGE}\nfrom\t\tllamap.cpp rel $LLAMACPP_VER"

[ "$(which figlet)" ] && printf "${MESSAGE}" | expand | figlet -t
printf "\n${MESSAGE}\n\n"

cd ./docker

docker build . \
    --file "${DOCKERFILE}" \
    --tag "${IMAGENAME}:${LLAMACPP_VER}" \
    --tag "${IMAGENAME}:latest" \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false

../cleanup-wsl-cache.sh