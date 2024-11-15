#!/bin/bash
# from: https://github.com/intel-analytics/ipex-llm/blob/main/docs/mddocs/DockerGuides/docker_cpp_xpu_quickstart.md
#
# Does ipex give us better performance / access to this igpu?
#

./cleanup-wsl-cache.sh
source ./settings.sh

export DOCKER_IMAGE=intelanalytics/ipex-llm-inference-cpp-xpu:latest
export CONTAINER_NAME=ipex-llm-inference-cpp-xpu-container

# shrank total memory
sudo docker run -itd \
                --rm \
                --net=host \
                --device=/dev/dri \
                \
                --device=/dev/dxg \
                --device=/dev/dri/card0 \
                --device=/dev/dri/renderD128 \
                -v /usr/lib/wsl:/usr/lib/wsl \
                -v /usr/lib/x86_64-linux-gnu/dri:/usr/lib/x86_64-linux-gnu/dri \
                \
                -v "$(realpath ../models)":/models \
                -e no_proxy=localhost,127.0.0.1 \
                --memory="24G" \
                --name=$CONTAINER_NAME \
                -e bench_model="/mistralai/mistral-v0.3/Mistral-7B-Instruct-v0.3-Q5_K_M.gguf" \
                -e DEVICE=Arc \
                --shm-size="16g" \
                $DOCKER_IMAGE
