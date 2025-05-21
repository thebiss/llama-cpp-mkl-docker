#!/usr/bin/echo Source this instead.

MODELDIR="$(realpath $HOME/models)"
MODELNAME="ibm/granite-3.1/granite-3.1-1b-a400m-instruct-Q6_K_L.gguf"

export LLAMA_BENCH_OPTS="--threads 8"
export LLAMA_ARG_MODEL="/var/models/${MODELNAME}"
export HF_TOKEN="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"
