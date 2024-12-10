#! /bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail

# Import misc bash tools
source ./docker/src/stdbash.sh


##
## Main
##


# load defaults
source ./settings.sh

# clear wsl FS buffer; will crash WSL when full
./cleanup-wsl-cache.sh

# Use model in param 1, if set
[ $# -gt 0 ] && LLAMA_MODEL_GGUF=$1
LLAMA_MODEL_GGUF=${LLAMA_MODEL_GGUF:-""}

# if still unset, use the default
if [ -z "${LLAMA_MODEL_GGUF}" ]; then
    LLAMA_MODEL_GGUF="${_MODEL_DEFAULT}"
    stdbash::warn "Using model from settings. Run \"${_THIS} /path/to/model.gguf\" to override."
fi

# Validate existence of absolute path
LLAMA_MODEL_GGUF=$(realpath ${LLAMA_MODEL_GGUF})
[ -f "${LLAMA_MODEL_GGUF}" ] || stdbash::error "Cannot access model file:" "${LLAMA_MODEL_GGUF}"

# Parts, for mounting
_LLAMA_MODEL_GGUF_FILEONLY=$(basename "${LLAMA_MODEL_GGUF}")
_LLAMA_MODEL_GGUF_DIRNAME=$(dirname "${LLAMA_MODEL_GGUF}")

echo "Using model ${_LLAMA_MODEL_GGUF_FILEONLY}"
[ -n "`which figlet`"  ] && figlet -w 120 "${_LLAMA_MODEL_GGUF_FILEONLY}"

_CONTAINER_MODEL_HOME="/var/models"
_CONTAINER_MODEL_ABS="${_CONTAINER_MODEL_HOME}/${_LLAMA_MODEL_GGUF_FILEONLY}"


# On ubuntu on WSL, open a browser
[ $(which sensible-browser) ] && sensible-browser http://localhost:8080

# Run the container
set -x
docker run \
    -it \
    --rm \
    --volume "${_LLAMA_MODEL_GGUF_DIRNAME}:${_CONTAINER_MODEL_HOME}:ro" \
    --publish 8080:8080 \
    --env "LLAMA_ARG_MODEL=${_CONTAINER_MODEL_ABS}" \
    --env "LLAMA_ARG_CTX_SIZE" \
    --env "LLAMA_ARG_FLASH_ATTN=${LLAMA_ARG_FLASH_ATTN:-"1"}" \
    --env "LLAMA_ARG_THREADS=${LLAMA_ARG_THREADS:-"8"}" \
    --env "LLAMA_ARG_HOST=${LLAMA_ARG_HOST:-"0.0.0.0"}" \
    --env "LLAMA_ARG_PORT=${LLAMA_ARG_PORT:-"8080"}" \
    --env "LLAMA_ARG_N_PREDICT=${LLAMA_ARG_N_PREDICT:-"-1"}" \
    --env "LLAMA_SERVER_EXTRA_OPTIONS" \
    --name "llama-cpp-mkl-optimized" \
    bbissell/llama-cpp-mkl:latest
set +x
