#! /bin/bash

# Default to b3467 if not specified
LLAMACPP_VER=${LLAMACPP_VER:-b3467}

docker build \
    -t bbissell/llama-cpp-mkl:${LLAMACPP_VER} \
    -t bbissell/llama-cpp-mkl:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false \
    .

docker images

