#! /bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail

_THIS=$(basename "$0")

##
## Print params as error, then exit -1
##
function _error
{
    [ $# -gt 0 ] && echo "${_THIS} Error: ${@:1}" && echo ""
    exit -1
}



##
## Main
##

# load defaults
source ./settings.sh

# Use model in param 1, if set
[ $# -gt 0 ] && LLAMA_MODEL_GGUF=$1
LLAMA_MODEL_GGUF=${LLAMA_MODEL_GGUF:-""}

# if still unset, use the default
if [ -z "${LLAMA_MODEL_GGUF}" ]; then
    LLAMA_MODEL_GGUF="${_MODEL_DEFAULT}"
    echo "WARNING: Model not set, using default. Run \"${_THIS} /path/to/model.gguf\" to override."
    echo ""
fi


# Validate existence of absolute path
LLAMA_MODEL_GGUF=$(realpath ${LLAMA_MODEL_GGUF})
[ -f "${LLAMA_MODEL_GGUF}" ] || _error "Cannot access model file:" "${LLAMA_MODEL_GGUF}"

# Parts, for mounting
_LLAMA_MODEL_GGUF_FILEONLY=$(basename "${LLAMA_MODEL_GGUF}")
_LLAMA_MODEL_GGUF_DIRNAME=$(dirname "${LLAMA_MODEL_GGUF}")

echo "Using model ${_LLAMA_MODEL_GGUF_FILEONLY}"
[ -n "`which figlet`"  ] && figlet -w 120 -k "${_LLAMA_MODEL_GGUF_FILEONLY}"

# Warn - passing context size specs
LLAMA_ARG_CTX_SIZE=${LLAMA_ARG_CTX_SIZE:-""}
[ -n "${LLAMA_ARG_CTX_SIZE}" ] && echo "Using context size limit from LLAMA_ARG_CTX_SIZE, ${LLAMA_ARG_CTX_SIZE}"

## force limit the context size on vulkan
LLAMA_ARG_CTX_SIZE=4096

# Run the container
set -x
docker run \
    -it \
    --rm \
    --device=/dev/dxg \
    --device=/dev/dri/card0 \
    --device=/dev/dri/renderD128 \
    --group-add video \
    -e DISPLAY \
    -e WAYLAND_DISPLAY \
    -e XDG_RUNTIME_DIR \
    -e LD_LIBRARY_PATH=/usr/lib/wsl/lib \
    -e LIBVA_DRIVER_NAME=d3d12 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /mnt/wslg:/mnt/wslg \
    -v /usr/lib/wsl:/usr/lib/wsl \
    -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri \
    \
    --volume "${_LLAMA_MODEL_GGUF_DIRNAME}:/var/models:ro" \
    --publish 8080:8080 \
    --env "LLAMA_MODEL_GGUF=${_LLAMA_MODEL_GGUF_FILEONLY}" \
    --env "LLAMA_ARG_CTX_SIZE" \
    --name "llama-cpp-mkl-optimized" \
    bbissell/llama-cpp-vulkan:latest
set +x

# On ubuntu on WSL, open a browser
[ $(which sensible-browser) ] && sensible-browser http://localhost:8080

