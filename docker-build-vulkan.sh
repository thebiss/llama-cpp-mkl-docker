#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}

cd ./docker

printf "\nBuilding from llamap.cpp version $LLAMACPP_VER\n\n"

docker build . \
    --file llama-server-vulkan.Dockerfile \
    --tag bbissell/llama-cpp-vulkan:${LLAMACPP_VER} \
    --tag bbissell/llama-cpp-vulkan:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false

../cleanup-wsl-cache.sh