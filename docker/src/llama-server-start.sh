#!/usr/bin/bash
set -euo pipefail


## Print params as error, then exit -1
function _error
{
    [ $# -gt 0 ] && echo "Error: ${@:1}" && echo ""
    exit -1
}

function _warn
{
    [ $# -gt 0 ] && echo "WARNING: ${@:1}" && echo ""    
}


##
## MODELS
##

#
_MODELHOME="/var/models"

_GGUF=${LLAMA_MODEL_GGUF:-}
[ -z "${_GGUF}" ] && _error 'Unknown model.  Set $LLAMA_MODEL_GGUF to model file name.'

_GGUF_ABSOLUTE="${_MODELHOME}/${_GGUF}"
[ -f "${_GGUF_ABSOLUTE}" ] || _error "Cannot access model file" "${_GGUF_ABSOLUTE}" "`ls -al ${_GGUF_ABSOLUTE}`"

_MODEL_PARAMS="-m ${_GGUF_ABSOLUTE}"


##
## Engine
##
#
_BIN=${LLAMA_SERVER_BIN:-""}
[ -z "${_BIN}" ] && _error 'Unknown llama-server.  Set $LLAMA_SERVER_BIN to path.'


## Engine Settings
_PROC_PARAMS="--threads 8 --host 0.0.0.0 --port 8080"


## CONTEXT settings
_KEEP_ORIGINAL_PROMPT="--keep -1"
_PREDICT_UNTIL_CONTEXT="--predict -1"

_CONTEXT_PARAMS="${_KEEP_ORIGINAL_PROMPT} ${_PREDICT_UNTIL_CONTEXT}"


## SAMPLING settings

# @BUG: It appears the llama.cpp UI overrides context and sampling settings...
_SAMPLING_PARAMS="--temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256"


## PROMPT
# not supported by server?
# _PROMPT="This is a conversation between User and Llama, a friendly chatbot. Llama is helpful, accurate, correct, clear, and concise.  Llama does not add extra phrases to be polite."

##
## MAIN
##

# Redundant. builds based upon intel oneapi base set this on startup; others can't set these
# SETVARS_COMPLETED=${SETVARS_COMPLETED:-}
# [ -z "${SETVARS_COMPLETED}" ] && _warn "Needs Intel MKL library env. First run: 'source /opt/intel/oneapi/setvars.sh'"

[ -n "`which figlet`"  ] && figlet -w 120 "=> LLAMA-SERVER ${LLAMACPP_VERSION}"

set -x
${_BIN} ${_PROC_PARAMS} ${_CONTEXT_PARAMS} ${_SAMPLING_PARAMS} ${LLAMA_SERVER_EXTRA_OPTIONS:-} ${_MODEL_PARAMS}

