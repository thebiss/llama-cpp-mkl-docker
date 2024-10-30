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

# clear wsl FS buffer; will crash WSL when full
./cleanup-wsl-cache.sh

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
[ -n "`which figlet`"  ] && figlet -w 120 -k --metal "${_LLAMA_MODEL_GGUF_FILEONLY}"

# Warn - passing context size specs
LLAMA_ARG_CTX_SIZE=${LLAMA_ARG_CTX_SIZE:-""}
[ -n "${LLAMA_ARG_CTX_SIZE}" ] && echo "Using context size limit from LLAMA_ARG_CTX_SIZE, ${LLAMA_ARG_CTX_SIZE}"

# Run the container
set -x
docker run \
    --detach \
    --rm \
    --volume "${_LLAMA_MODEL_GGUF_DIRNAME}:/var/models:ro" \
    --publish 8080:8080 \
    --env "LLAMA_MODEL_GGUF=${_LLAMA_MODEL_GGUF_FILEONLY}" \
    --env "LLAMA_ARG_CTX_SIZE" \
    --name "llama-cpp-mkl-optimized" \
    bbissell/llama-cpp-mkl:latest
set +x

# On ubuntu on WSL, open a browser
[ $(which sensible-browser) ] && sensible-browser http://localhost:8080

