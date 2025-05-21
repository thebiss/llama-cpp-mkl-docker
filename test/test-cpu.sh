#!/bin/bash

# free buffers
../cleanup-wsl-cache.sh

source test-settings.sh

DOCKER_IMAGE_COMMAND="/bin/bash"

pushd ..
source start-server.sh
popd

