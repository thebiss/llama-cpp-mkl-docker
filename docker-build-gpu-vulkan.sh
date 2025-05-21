#! /bin/bash

source ./settings.sh

DOCKERFILE=llama-server-gpu-vulkan.Dockerfile
IMAGENAME=thebiss/llama-cpp-vulkan

source ./docker-build-common.sh
