#! /bin/bash
##
##
## Runs the containerized model using a specified model, or local default.
##
##
set -euo pipefail

##
## Print params as error, then exit -1
##
function _error
{
    [ $# -gt 0 ] && echo "Error: ${@:1}" && echo ""
    exit -1
}



##
## Main
##
_MODEL_DEFAULT="../models/Mistral-7B-Instruct-v0.3-Q5_K_M.gguf"
_MODEL_MSG=""
LLAMA_MODEL_GGUF=${LLAMA_MODEL_GGUF:-""}


# Accept model as param 1, overriding env if set
[ $# -gt 0 ] && LLAMA_MODEL_GGUF=$1

# if still unset, use the default
if [ -z "${LLAMA_MODEL_GGUF}" ]; then
    LLAMA_MODEL_GGUF="${_MODEL_DEFAULT}"
    _MODEL_MSG="Warning: Model not set, using default. Run \"$(basename $0) /path/to/model.gguf\" to override."
fi


echo "Using model ${LLAMA_MODEL_GGUF}"
echo "${_MODEL_MSG}"

# Validate existence of absolute path
LLAMA_MODEL_GGUF=$(realpath ${LLAMA_MODEL_GGUF})
[ -f "${LLAMA_MODEL_GGUF}" ] || _error "Cannot access model file:" "${LLAMA_MODEL_GGUF}"


# Parts, for mounting
_LLAMA_MODEL_GGUF_FILEONLY=$(basename "$LLAMA_MODEL_GGUF")
_LLAMA_MODEL_GGUF_DIRNAME=$(dirname "$LLAMA_MODEL_GGUF")

# Run the container
set -x
docker run \
    -it \
    --rm \
    --volume "${_LLAMA_MODEL_GGUF_DIRNAME}:/var/models:ro" \
    --publish 8080:8080 \
    --env "LLAMA_MODEL_GGUF=${_LLAMA_MODEL_GGUF_FILEONLY}" \
    --name "llama-cpp-mkl-optimized" \
    bbissell/llama-cpp-mkl:latest
