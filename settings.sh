#!/usr/bin/echo Source this instead.

# LLAMACPP release tag to build from
#
# prior     - Default to b3467 if not specified
# 19 Aug    - b3486 for Ollama, which includes issue #8688
# 19 Aug    - b3599
# 13 Sept   - b3751
# 23 Sept   - b3812
# 24 Oct    - b3974 - better server prompt handling + more
# 4 Nov     - b3989 - new vulkan ops
# 9 Nov     - b4048 - better UI, other q6 opts
# 11 Nov    - b4066 - more sycl acceleration from commit 3bcd40b
# 15 Nov    - b4069 - try the fixes to test-backend-ops ; still out of bounds on GPU
#           - b4077 - test 
#           - b4082 new vers fails
LLAMACPP_VER=b4077
TIME_NOW_MINS="$(date -Iminutes | sed 's/\://g')"

_MODEL_ROOT="../models"
# Default model to run
## _MODEL_DEFAULT="${_MODEL_ROOT}/mistralai/mistral-v0.3/Mistral-7B-Instruct-v0.3-Q5_K_M.gguf"
_MODEL_DEFAULT="${_MODEL_ROOT}/ibm/granite-3.0/granite-3.0-8b-instruct-Q6_K.gguf"
