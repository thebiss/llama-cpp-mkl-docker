#! /bin/bash

# Default to b3467 if not specified
# 19 Aug - bump to b3486 for Ollama, which includes issue #8688
LLAMACPP_VER=${LLAMACPP_VER:-b3486}

docker build . \
    --file Dockerfile \
    --tag bbissell/llama-cpp-mkl:${LLAMACPP_VER} \
    --tag bbissell/llama-cpp-mkl:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false
