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
##
TMP_FILE=""
_atexit() {
    set +x
    local _exit_code=$?
    [ -f "${TMP_FILE}" ] && rm -vf "${TMP_FILE}"

    ./cleanup-wsl-cache.sh

    exit $_exit_code
}
trap _atexit EXIT
trap _atexit SIGINT SIGTERM SIGQUIT


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

stdbash::info "Using model ${_MODEL_GGUF_FILENAME} from ${_MODEL_GGUF_DIRNAME}"
[ -n "`which figlet`"  ] && figlet -w 120 "${_MODEL_GGUF_FILENAME}"

_CONTAINER_MODEL_HOME="/var/models"
_CONTAINER_MODEL_ABS="${_CONTAINER_MODEL_HOME}/${_MODEL_GGUF_FILENAME}"
LLAMA_ARG_MODEL="${_CONTAINER_MODEL_ABS}"

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

##
## Run the container
##

#
# Environment Variables - Pass via a .env file
#

# Export anything set with the name LLAMA_ARG or LLAMA_SERVER, from:
# - wrapping scripts
# - the initizationization above
# - defaults in settings.sh
export $(compgen -v LLAMA_ARG_)
export LLAMA_SERVER_EXTRA_OPTIONS


# create envfile
TMP_FILE="$(mktemp --tmpdir tmp.llamaserver.XXXXX.env)"
stdbash::info "Passing environment via ${TMP_FILE}."
env | grep -e '^LLAMA_ARG_' -e '^LLAMA_SERVER_' | sort > "${TMP_FILE}"

#
set -x
docker run \
    -it \
    --rm \
    --volume "${_MODEL_GGUF_DIRNAME}:${_CONTAINER_MODEL_HOME}:ro" \
    ${DOCKER_RUN_ARGS} \
    --env-file "${TMP_FILE}" \
    --publish 8080:8080 \
    --name "${DOCKER_CONTAINER_NAME}" \
    ${DOCKER_IMAGE_NAME}
set +x

