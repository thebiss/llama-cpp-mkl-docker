#! /bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail

DOCKER_RUN_ARGS="\
    --device=/dev/dxg \
    --device=/dev/dri/card0 \
    --device=/dev/dri/renderD128 \
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

DOCKER_IMAGE_NAME="thebiss/llama-cpp-vulkan:latest"
DOCKER_CONTAINER_NAME="llama-cpp-mkl-optimized"

source ./start-server.sh
