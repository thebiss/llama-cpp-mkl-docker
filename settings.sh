#!/usr/bin/echo Source this instead.

# Build LLAMACPP release tag...
# LLAMACPP_VER=b4295
LLAMACPP_VER=b4301
TIME_NOW_MINS="$(date -Iminutes | sed 's/\://g')"

_MODEL_ROOT="../models"
# Default model to run
## MODEL_DEFAULT="${_MODEL_ROOT}/mistralai/mistral-v0.3/Mistral-7B-Instruct-v0.3-Q5_K_M.gguf"
MODEL_DEFAULT="${_MODEL_ROOT}/ibm/granite-3.0/granite-3.0-8b-instruct-Q6_K.gguf"
