#!/usr/bin/bash
set -euo pipefail

source stdbash.sh

##
## MODELS
##

#
LLAMA_ARG_MODEL=${LLAMA_ARG_MODEL:-""}
[ -z "${LLAMA_ARG_MODEL}" ] && stdbash::error 'Unknown model.  Set $LLAMA_ARG_MODEL to absolute path to model file gguf.'
[ -f "${LLAMA_ARG_MODEL}" ] || stdbash::error "Cannot access model file" "${LLAMA_ARG_MODEL}" "`ls -al ${LLAMA_ARG_MODEL}`"
export LLAMA_ARG_MODEL


##
## Engine
##
#
LLAMA_SERVER_BIN=${LLAMA_SERVER_BIN:-""}
[ -z "${LLAMA_SERVER_BIN}" ] && stdbash::error 'Unknown llama-server.  Set $LLAMA_SERVER_BIN to path.'


## PROMPT
# not supported by server?
# _PROMPT="This is a conversation between User and Llama, a friendly chatbot. Llama is helpful, accurate, correct, clear, and concise.  Llama does not add extra phrases to be polite."

##
## "MAIN"
##
[ -n "`which figlet`"  ] && figlet -w 120 "=> LLAMA-SERVER ${LLAMACPP_VERSION}"

printf '\nENVIRONMENT (LLAMA_*):\n'
env | grep 'LLAMA_' | sort | sed 's/^/  /'
printf "\n"

set -x
${LLAMA_SERVER_BIN} ${LLAMA_SERVER_EXTRA_OPTIONS:-}

