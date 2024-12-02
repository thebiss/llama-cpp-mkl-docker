#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}
DOCKERFILE=llama-server-vulkan.Dockerfile
IMAGE=llama-cpp-vulkan

source ./docker-build-common.sh
