#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 

# Lessons learned
# - must passthrough the directx device and dri's 
# - user must be in the video group, render group not needed, does not need root
# - needs /usr/lib/wsl

# free buffers
../cleanup-wsl-cache.sh

source test-settings.sh

# 7 Nov -remove extraneous mounts and vars

# Run the container
DOCKER_RUN_ARGS="\
    --device=/dev/dxg \
    --device=/dev/dri/card0 \
    --device=/dev/dri/renderD128 \
    --volume /usr/lib/wsl:/usr/lib/wsl"
    
DOCKER_IMAGE_NAME="thebiss/llama-cpp-mkl-gpu:latest"
DOCKER_IMAGE_COMMAND="/bin/bash"

pushd ..
source ./start-server.sh
popd
