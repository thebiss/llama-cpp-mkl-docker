#! /bin/bash

source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-}
DOCKERFILE=llama-server-onemkl-cpu.Dockerfile
IMAGENAME=thebiss/llama-cpp-mkl

source ./docker-build-common.sh