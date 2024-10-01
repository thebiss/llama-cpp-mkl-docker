#! /bin/bash

# Default to b3467 if not specified
# 19 Aug - bump to b3486 for Ollama, which includes issue #8688
# 19 Aug    - try b3599
# 13 Sept - try 3751
# 23 Sept - try b3812
LLAMACPP_VER=${LLAMACPP_VER:-b3812}

cd ./docker

printf "\nBuilding from llamap.cpp version $LLAMACPP_VER\n\n"

docker build . \
    --file llama-server-vulkan.Dockerfile \
    --tag bbissell/llama-cpp-vulkan:${LLAMACPP_VER} \
    --tag bbissell/llama-cpp-vulkan:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false
