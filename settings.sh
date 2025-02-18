#!/usr/bin/echo Source this instead.

# Build LLAMACPP release tag...
LLAMACPP_VER=b4738

# Default model to run
MODEL_HOME="${HOME}/models"
MODEL_DEFAULT="${MODEL_HOME}/ibm/granite-3.1/granite-3.1-8b-instruct-Q6_K.gguf"

LLAMA_ARG_CTX_SIZE=${LLAMA_ARG_CTX_SIZE:-"8192"}

# LLAMA-SERVER defaults settings, as environment variables
# Only sets values if not already set
LLAMA_ARG_FLASH_ATTN=${LLAMA_ARG_FLASH_ATTN:-"1"}
LLAMA_ARG_THREADS=${LLAMA_ARG_THREADS:-"8"}
LLAMA_ARG_HOST=${LLAMA_ARG_HOST:-"0.0.0.0"}
LLAMA_ARG_PORT=${LLAMA_ARG_PORT:-"8080"}
LLAMA_ARG_N_PREDICT=${LLAMA_ARG_N_PREDICT:-"-1"}

# LLAMA_ARG_CACHE_TYPE_K=${LLAMA_ARG_CACHE_TYPE_K:-"q8_0"}
# LLAMA_ARG_CACHE_TYPE_V=${LLAMA_ARG_CACHE_TYPE_V:-"q8_0"}

##
## PROMPT & CONTEXT - these have no env var equivalents.
##
#--keep -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256
#--keep -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256

LLAMA_SERVER_EXTRA_OPTIONS="--keep -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256"
 