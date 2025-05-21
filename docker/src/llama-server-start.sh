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

## PROMPT
# not supported by server?
# _PROMPT="This is a conversation between User and Llama, a friendly chatbot. Llama is helpful, accurate, correct, clear, and concise.  Llama does not add extra phrases to be polite."

##
## "MAIN"
##
[ -n "`which figlet`"  ] && figlet -w 120 "=> LLAMA-SERVER ${LLAMA_CPP_VERSION}"

printf '\nENVIRONMENT (LLAMA_*):\n'
env | grep 'LLAMA_' | sort | sed 's/^/  /'
printf "\n"

# prevent core dumps due to ^C bug
ulimit -c 0

set -x
llama-server ${LLAMA_CPP_EXTRA_OPTIONS:-}

