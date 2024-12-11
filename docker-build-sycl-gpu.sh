#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}
DOCKERFILE=llama-server-sycl-gpu.Dockerfile
IMAGENAME=thebiss/llama-cpp-mkl-gpu

source ./docker-build-common.sh
