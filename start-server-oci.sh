#! /bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail

set -x


# Import misc bash tools
source lib/libbbash.sh


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

## Modelfile name passed - use that
## Otherwise, use $MODEL_HOME and $LLAMA_ARG_MODEL

[ $# -gt 0 ] && _MODEL_GGUF="${1}"
_MODEL_GGUF="${_MODEL_GGUF:-$LLAMA_ARG_MODEL}"

# Convert the path to absolute
_MODEL_GGUF=$(realpath ${_MODEL_GGUF})

# Validate access to file
[ -f "${_MODEL_GGUF}" ] || stdbash::error "Cannot access model file: " "${_MODEL_GGUF}"

# Separate name parts, for mounting
_MODEL_GGUF_FILENAME=$(basename "${_MODEL_GGUF}")
_MODEL_GGUF_DIRNAME=$(dirname "${_MODEL_GGUF}")

# Override the defaults
MODEL_HOME="${_MODEL_GGUF_DIRNAME}"
LLAMA_ARG_MODEL="${_MODEL_GGUF_FILENAME}"

stdbash::info "Using model ${LLAMA_ARG_MODEL} from ${MODEL_HOME}"
[ -n "`which figlet`"  ] && figlet -w 120 "${LLAMA_ARG_MODEL}"


#
# CONTAINER SETUP
#  - Set the container args, image and name
#

# set to add additional flags, envs, and devices at start
DOCKER_RUN_ARGS=${DOCKER_RUN_ARGS:-""}
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME:-"localhost/thebiss/llama-cpp-mkl:latest"}
DOCKER_IMAGE_COMMAND=${DOCKER_IMAGE_COMMAND:-""}
DOCKER_CONTAINER_NAME=${DOCKER_CONTAINER_NAME:-"llama-cpp-pod"}


# Open a browser to the default URL
#   If the command to do so exists.
#   If the command-line wasn't set.
[ $(which sensible-browser) ] && [ -z "${DOCKER_IMAGE_COMMAND}" ] && sensible-browser http://localhost:8080


# Cache KV
LLAMA_CPP_EXTRA_OPTIONS="$LLAMA_CPP_EXTRA_OPTIONS --slot-save-path /home/llamauser/.cache/llama.cpp"


##
## Run the container
##

#
# Environment Variables - Pass via a .env file
#

# Export anything set with the name LLAMA_ARG or LLAMA_CPP, from:
# - wrapping scripts
# - the initizationization above
# - defaults in settings.sh
export $(compgen -v LLAMA_)


# create envfile
TMP_FILE="$(mktemp --tmpdir tmp.llamaserver.XXXXX.env)"
stdbash::info "Passing environment via ${TMP_FILE}."
env | grep -e '^LLAMA_' | sort > "${TMP_FILE}"


#
set -x
docker run \
    -it \
    --rm \
    --replace \
    --volume "${MODEL_HOME}:${_CONTAINER_MODEL_HOME}:ro" \
    --volume "${HOME}/.cache/llama.cpp:/home/llamauser/.cache/llama.cpp:rw,idmap" \
    ${DOCKER_RUN_ARGS} \
    --env-file "${TMP_FILE}" \
    --publish "8080:${LLAMA_ARG_PORT}" \
    --name "${DOCKER_CONTAINER_NAME}" \
    ${DOCKER_IMAGE_NAME} ${DOCKER_IMAGE_COMMAND}
set +x

