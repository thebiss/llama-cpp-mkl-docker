
#!/bin/bash

# Tips from: https://github.com/microsoft/wslg/issues/531
# and https://github.com/jnewb1/vgpu-docker-wslg-testing 
# and https://github.com/microsoft/wslg/blob/main/samples/container/Containers.md
# and see here that GPUs in LUNUX contaners are not supported:
#    https://learn.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/gpu-acceleration#hyper-v-isolated-linux-container-support

# Lessons learned
# - must passthrough the directx device - don't need the dri's 
# - user must be in the video group, render group not needed, does not need root
# - don't need  --device=/dev/dri/card0 \
# - don't need  --device=/dev/dri/renderD128 \

# free buffers
./cleanup-wsl-cache.sh

MODELDIR="$(realpath ../models)"

# Run the container
set -x
docker run -it --rm \
    --device=/dev/dxg \
    --device=/dev/dri/card0 \
    --device=/dev/dri/renderD128 \
    --group-add video \
    --env DISPLAY \
    --env WAYLAND_DISPLAY \
    --env XDG_RUNTIME_DIR \
    --env LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    --env LIBVA_DRIVER_NAME=d3d12 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /mnt/wslg:/mnt/wslg \
    -v /usr/lib/wsl:/usr/lib/wsl \
    -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri \
    --volume "${MODELDIR}:/var/models:ro" \
    --name "test-llamacpp-vulkan" \
    bbissell/llama-cpp-vulkan:latest \
    /bin/bash

