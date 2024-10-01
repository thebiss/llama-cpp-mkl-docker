#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 

# Lessons learned
# - must passthrough the directx device - don't need the dri's 
# - user must be in the video group, render group not needed, does not need root
# - don't need  --device=/dev/dri/card0 \
# - don't need  --device=/dev/dri/renderD128 \

docker run -it \
    --device=/dev/dxg \
    --group-add video \
    -e DISPLAY \
    -e WAYLAND_DISPLAY \
    -e XDG_RUNTIME_DIR \
    -e LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /mnt/wslg:/mnt/wslg \
    -v /usr/lib/wsl:/usr/lib/wsl \
    -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri \
    bbissell/llama-cpp-mkl-gpu:latest /bin/bash
    # intel/oneapi-basekit:2024.2.1-0-devel-ubuntu22.04 /bin/bash
    

exit 0;

#    
# --group-add 118 \

