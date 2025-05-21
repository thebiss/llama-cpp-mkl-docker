#! /bin/bash

source ./settings.sh

DOCKERFILE=llama-server-cpu-onemkl.Dockerfile
IMAGENAME=thebiss/llama-cpp-mkl

source ./docker-build-common.sh