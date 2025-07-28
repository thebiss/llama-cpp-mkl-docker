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
    --group-add video \
    --env DISPLAY \
    --env WAYLAND_DISPLAY \
    --env XDG_RUNTIME_DIR \
    --env LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    --env LIBVA_DRIVER_NAME=d3d12 \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --volume /mnt/wslg:/mnt/wslg \
    --volume /usr/lib/wsl:/usr/lib/wsl \
    --volume /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri"

DOCKER_IMAGE_NAME="localhost/thebiss/llama-cpp-vulkan:latest"
DOCKER_IMAGE_COMMAND="/bin/bash"

pushd ..
source ./start-server.sh
popd
