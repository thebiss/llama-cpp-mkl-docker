#!/usr/bin/echo Source this instead.

## Build LLAMACPP release tag...
## min 4778 for granite 3.2 quant support
## min 5146 for grainte 3.3 FIM tokens
# LLAMA_CPP_VERSION=b5146
# LLAMA_CPP_VERSION=b5218
# LLAMA_CPP_VERSION=b5261
# LLAMA_CPP_VERSION=b5293
# LLAMA_CPP_VERSION=b5363
LLAMA_CPP_VERSION=b5402

# Default model to run
MODEL_HOME="${HOME}/models"
MODEL_DEFAULT="${MODEL_HOME}/ibm/granite-3.3/granite-3.3-8b-instruct-Q6_K.gguf"

##
## LLAMA-SERVER default settings, as environment variables
## Only sets values if not already set
##

# 17 May - faster without FA
LLAMA_ARG_FLASH_ATTN=${LLAMA_ARG_FLASH_ATTN:-"0"}

LLAMA_ARG_THREADS=${LLAMA_ARG_THREADS:-"8"}
LLAMA_ARG_HOST=${LLAMA_ARG_HOST:-"0.0.0.0"}
LLAMA_ARG_PORT=${LLAMA_ARG_PORT:-"8080"}
LLAMA_ARG_N_PREDICT=${LLAMA_ARG_N_PREDICT:-"-1"}
LLAMA_ARG_CTX_SIZE=${LLAMA_ARG_CTX_SIZE:-"8192"}

# PROMPT & CONTEXT - these have no env var equivalents.
LLAMA_CPP_EXTRA_OPTIONS="${LLAMA_CPP_EXTRA_OPTIONS:-} --keep -1 --temp 0.4 --top-k 40 --top-p 0.95 --min-p 0.05 --repeat-penalty 256"
 