#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}
DOCKERFILE=llama-server-onemkl-cpu.Dockerfile
IMAGENAME=bbissell/llama-cpp-mkl

cd ./docker

printf "\nBuilding from llamap.cpp version $LLAMACPP_VER\n\n"

docker build . \
    --file "${DOCKERFILE}" \
    --tag "${IMAGENAME}:${LLAMACPP_VER}" \
    --tag "${IMAGENAME}:latest" \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false

../cleanup-wsl-cache.sh