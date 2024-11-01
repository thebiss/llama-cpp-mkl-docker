#! /bin/bash

# Default to b3467 if not specified
# 19 Aug - bump to b3486 for Ollama, which includes issue #8688
# 19 Aug    - try b3599
# 13 Sept - try 3751
# 23 Sept - try b3812
# 24 Oct - try b3974 - better server prompt handling + more
source ./settings.sh

LLAMACPP_VER=${LLAMACPP_VER:-b3974}

cd ./docker

printf "\nBuilding from llamap.cpp version $LLAMACPP_VER\n\n"

docker build . \
    --file llama-server-onemkl-avx512.Dockerfile \
    --tag bbissell/llama-cpp-mkl:${LLAMACPP_VER} \
    --tag bbissell/llama-cpp-mkl:latest \
    --build-arg LLAMACPP_VERSION_TAG=${LLAMACPP_VER} \
    --rm=false

./cleanup-wsl-cache.sh
