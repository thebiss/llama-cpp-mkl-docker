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
_LLAMA_MODEL_MSG=${LLAMA_MODEL_GGUF:-"Warning: Using a default model; set LLAMA_MODEL_GGUF to override."}
LLAMA_MODEL_GGUF=${LLAMA_MODEL_GGUF:-$HOME/dev-in-wsl/models/mistral-7b-instruct-v0.2.Q5_K_M.gguf}

echo "Using model ${LLAMA_MODEL_GGUF}"
echo "${_LLAMA_MODEL_MSG}"


[ -f "${LLAMA_MODEL_GGUF}" ] || error "Cannot access model file:" "${LLAMA_MODEL_GGUF}"


_LLAMA_MODEL_GGUF_FILEONLY=$(basename "$LLAMA_MODEL_GGUF")
_LLAMA_MODEL_GGUF_DIRNAME=$(dirname "$LLAMA_MODEL_GGUF")

#
set -x
docker run \
    -it \
    -v "${_LLAMA_MODEL_GGUF_DIRNAME}:/var/models:ro" \
    -p 8080:8080 \
    -e "LLAMA_MODEL_GGUF=${_LLAMA_MODEL_GGUF_FILEONLY}" \
    bbissell/llama-cpp-mkl 
