#! /bin/bash

# Default to b3467 if not specified
LLAMACPP_VER=${LLAMACPP_VER:-b3472}

docker build . \
    --file Dockerfile \
    --tag bbissell/llama-cpp-mkl:${LLAMACPP_VER} \
    --tag bbissell/llama-cpp-mkl:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false
