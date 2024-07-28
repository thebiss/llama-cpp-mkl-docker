#! /bin/bash
export LLAMACPP_VER=b3467

docker build \
    -t bbissell/llama-cpp-mkl:${LLAMACPP_VER} \
    -t bbissell/llama-cpp-mkl:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false \
    .

docker images

