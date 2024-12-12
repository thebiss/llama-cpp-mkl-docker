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

#
# Model Filename - Check and Demangle
#

# Use model in param 1, if set
[ $# -gt 0 ] && _MODEL_GGUF="${1}"
_MODEL_GGUF=${_MODEL_GGUF:-""}

# If model not set, use the default
if [ -z "${_MODEL_GGUF}" ]; then
    _MODEL_GGUF="${MODEL_DEFAULT}"
    stdbash::warn "Using model from settings. Run \"${_THIS} /path/to/model.gguf\" to override."
fi


# Convert the path to absolute
_MODEL_GGUF=$(realpath ${_MODEL_GGUF})

# Validate access to file
[ -f "${_MODEL_GGUF}" ] || stdbash::error "Cannot access model file:" "${_MODEL_GGUF}"

# Separate name parts, for mounting
_MODEL_GGUF_FILENAME=$(basename "${_MODEL_GGUF}")
_MODEL_GGUF_DIRNAME=$(dirname "${_MODEL_GGUF}")

echo "Using model ${_MODEL_GGUF_FILENAME} from ${_MODEL_GGUF_DIRNAME}"
[ -n "`which figlet`"  ] && figlet -w 120 "${_MODEL_GGUF_FILENAME}"

_CONTAINER_MODEL_HOME="/var/models"
_CONTAINER_MODEL_ABS="${_CONTAINER_MODEL_HOME}/${_MODEL_GGUF_FILENAME}"


#
# CONTAINER SETUP
#  - Set the container args, image and name
#

# set to add additional flags, envs, and devices at start
DOCKER_RUN_ARGS=${DOCKER_RUN_ARGS:-""}
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"thebiss/llama-cpp-mkl:latest"}
DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME:-"llama-cpp-mkl-optimized"}


# On ubuntu on WSL, open a browser
[ $(which sensible-browser) ] && sensible-browser http://localhost:8080

#
# Run the container
#

# Env vars are either:
# - set by wrapping scripts
# - set by the initizationization above
# - set with defaults in settings.sh
# - unset
export $(compgen -v LLAMA_ARG_)
export LLAMA_SERVER_EXTRA_OPTIONS

set -x
docker run \
    -it \
    --rm \
    --volume "${_MODEL_GGUF_DIRNAME}:${_CONTAINER_MODEL_HOME}:ro" \
    ${DOCKER_RUN_ARGS} \
    --env "LLAMA_ARG_MODEL=${_CONTAINER_MODEL_ABS}" \
    --env "LLAMA_ARG_CTX_SIZE" \
    --env "LLAMA_ARG_FLASH_ATTN" \
    --env "LLAMA_ARG_THREADS" \
    --env "LLAMA_ARG_HOST" \
    --env "LLAMA_ARG_PORT" \
    --env "LLAMA_ARG_N_PREDICT" \
    --env "LLAMA_SERVER_EXTRA_OPTIONS" \
    --publish 8080:8080 \
    --name "${DOCKER_CONTAINER_NAME}" \
    ${DOCKER_IMAGE_NAME}
set +x
