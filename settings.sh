#!/usr/bin/echo Source this instead.

# Build LLAMACPP release tag...
# LLAMACPP_VER=b4295
LLAMACPP_VER=b4301
TIME_NOW_MINS="$(date -Iminutes | sed 's/\://g')"

# Default model to run
# MODEL_DEFAULT="../models/mistralai/mistral-v0.3/Mistral-7B-Instruct-v0.3-Q5_K_M.gguf"
MODEL_DEFAULT="../models/ibm/granite-3.0/granite-3.0-8b-instruct-Q6_K.gguf"

# LLAMA-SERVER defaults settings, as environment variables
# Only sets values if not already set
LLAMA_ARG_FLASH_ATTN=${LLAMA_ARG_FLASH_ATTN:-"1"}
LLAMA_ARG_THREADS=${LLAMA_ARG_THREADS:-"8"}
LLAMA_ARG_HOST=${LLAMA_ARG_HOST:-"0.0.0.0"}
LLAMA_ARG_PORT=${LLAMA_ARG_PORT:-"8080"}
LLAMA_ARG_N_PREDICT=${LLAMA_ARG_N_PREDICT:-"-1"}
