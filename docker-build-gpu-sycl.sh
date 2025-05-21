#! /bin/bash

source ./settings.sh

DOCKERFILE=llama-server-gpu-sycl.Dockerfile
IMAGENAME=thebiss/llama-cpp-mkl-gpu

source ./docker-build-common.sh
