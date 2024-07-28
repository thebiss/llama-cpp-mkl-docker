#!/usr/bin/bash

## Print params as error, then exit -1
function _error
{
    [ $# -gt 0 ] && echo "Error: ${@:1}" && echo ""
    exit -1
}

## MODELS
#
_MODELHOME="/var/models"
_GGUF="mistral-7b-instruct-v0.2.Q5_K_M.gguf"
# _GGUF="Phi-3-mini-4k-instruct-q4.gguf"
# _GGUF="Meta-Llama-3-8B-Instruct.Q5_K_M.gguf"

# needs new encoder
# _GGUF="Mistral-Nemo-Instruct-2407-Q5_K_M.gguf"

_MODEL_PARAMS="-m ${_MODELHOME}/${_GGUF}"


## Engine
#
_BIN=${LLAMA_SERVER_BIN:-"/home/llamacpp/build/bin/llama-server"}


## Engine Settings
# _GPU_OFF="" # "--gpu DISABLE"
# _THREADS="--threads 7"
#
_PROC_PARAMS="--threads 7 --host 0.0.0.0 --port 8080"


## CONTEXT settings
_KEEP_ORIGINAL_PROMPT="--keep -1"
_CONTEXT_FROM_MODEL="-c 0"
_PREDICT_UNTIL_CONTEXT="-n -2"
#
_CONTEXT_PARAMS="${_KEEP_ORIGINAL_PROMPT} ${_CONTEXT_FROM_MODEL} ${PREDUCT_UNTIL_CONTEXT}"


## SAMPLING settings
#
# Too match llamafile defaults for comparison purposes...
# _PREDICTIONS=400
# _PENALIZE_REPEAT=1.18
#
SAMPLING_PARAMS="--temp 0.7 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256"


## PROMPT
# not supported by server?
# _PROMPT="This is a conversation between User and Llama, a friendly chatbot. Llama is helpful, accurate, correct, clear, and concise.  Llama does not add extra phrases to be polite."


## Main

SETVARS_COMPLETED=${SETVARS_COMPLETED:-}
[ -z "${SETVARS_COMPLETED}" ] && echo "Needs Intel MKL library env. Running: 'source /opt/intel/oneapi/setvars.sh'" && source /opt/intel/oneapi/setvars.sh

set -x
${_BIN} ${_PROC_PARAMS} ${_CONTEXT_PARAMS} ${SAMPLING_PARAMS} ${_MODEL_PARAMS}

