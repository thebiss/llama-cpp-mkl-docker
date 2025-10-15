#!/bin/bash
##
##
## Runs the containerized llama-server using a specified or default model
##
##
set -euo pipefail


# Import misc bash tools
source lib/libbbash.sh


##
##
TMP_FILE=""
_atexit() {
    set +x
    local _exit_code=$?
    [ -f "${TMP_FILE}" ] && rm -vf "${TMP_FILE}"

    # ./cleanup-wsl-cache.sh

    exit $_exit_code
}
trap _atexit EXIT SIGINT SIGTERM SIGQUIT

##
## Main
##

# load defaults
source ./settings.sh

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
##_MODEL_GGUF_FILENAME=$(basename "${_MODEL_GGUF}")
##_MODEL_GGUF_DIRNAME=$(dirname "${_MODEL_GGUF}")

# Override the defaults
##MODEL_HOME="${_MODEL_GGUF_DIRNAME}"
LLAMA_ARG_MODEL="${_MODEL_GGUF}"

## stdbash::info "Using model ${LLAMA_ARG_MODEL} from ${MODEL_HOME}"
[ -n "`which figlet`"  ] && figlet -w 120 "${LLAMA_ARG_MODEL}"


#
#
# Environment Variables - Pass via a .env file
#

# Export anything set with the name LLAMA_ARG or LLAMA_CPP, from:
# - wrapping scripts
# - the initizationization above
# - defaults in settings.sh
export $(compgen -v LLAMA_)


# create envfile
#TMP_FILE="$(mktemp --tmpdir tmp.llamaserver.XXXXX.env)"
#stdbash::info "Passing environment via ${TMP_FILE}."
#env | grep -e '^LLAMA_' | sort > "${TMP_FILE}"



#
set -x
llama-server
set +x

