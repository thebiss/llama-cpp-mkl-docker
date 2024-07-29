#! /bin/bash

set -euo pipefail


## Print params as error, then exit -1
function _error
{
    [ $# -gt 0 ] && echo "Error: ${@:1}" && echo ""
    exit -1
}

##
## Main
##
_MODEL_DEFAULT="$HOME/dev-in-wsl/models/mistral-7b-instruct-v0.2.Q5_K_M.gguf"

# Accept model as param 1, or tuse the default
[ $# -gt 0 ] && LLAMA_MODEL_GGUF=$1

_LLAMA_MODEL_MSG=${LLAMA_MODEL_GGUF:-"Warning: Using a default model; run \"$(basename $0) /path/to/model.gguf\" to override."}
LLAMA_MODEL_GGUF=${LLAMA_MODEL_GGUF:-"$_MODEL_DEFAULT"}


echo "Using model ${LLAMA_MODEL_GGUF}"
echo "${_LLAMA_MODEL_MSG}"


# Relative to absolute path
LLAMA_MODEL_GGUF=$(realpath ${LLAMA_MODEL_GGUF})
# Validate existence
[ -f "${LLAMA_MODEL_GGUF}" ] || error "Cannot access model file:" "${LLAMA_MODEL_GGUF}"


# Parts, for mounting
_LLAMA_MODEL_GGUF_FILEONLY=$(basename "$LLAMA_MODEL_GGUF")
_LLAMA_MODEL_GGUF_DIRNAME=$(dirname "$LLAMA_MODEL_GGUF")

#
set -x
docker run \
    --detach \
    --rm \
    --volume "${_LLAMA_MODEL_GGUF_DIRNAME}:/var/models:ro" \
    --publish 8080:8080 \
    --env "LLAMA_MODEL_GGUF=${_LLAMA_MODEL_GGUF_FILEONLY}" \
    --name "llama-cpp-mkl-optimized" \
    bbissell/llama-cpp-mkl:latest
