##
## Build a llama.cpp instance that uses Intel SYCL GPU acceleration
##
ARG ONEAPI_VERSION=2025.0.0-0-devel-ubuntu22.04
# ARG ONEAPI_VERSION=2024.2.1-0-devel-ubuntu22.04

##
## Build Stage
##
FROM intel/oneapi-basekit:${ONEAPI_VERSION} AS build

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

ARG LLAMACPP_VERSION_TAG
RUN if [ -z "$LLAMACPP_VERSION_TAG" ]; then \
    echo "Error: arg LLAMACPP_VERSION_TAG must be set." && exit 1; \
    fi


ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

# Fetch from repo
ADD --chown=1010:1010 --keep-git-dir=true https://github.com/ggerganov/llama.cpp.git#${LLAMACPP_VERSION_TAG} git
WORKDIR /home/llamauser/git

# You can skip this step if  in oneapi-basekit docker image, only required for manual installation
# source /opt/intel/oneapi/setvars.sh 
RUN cmake -B build -DGGML_SYCL=ON -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx 
# -DGGML_SYCL_F16=ON

RUN cmake --build build -j $(nproc) \
    --config Release \
    --target llama-server \
    --target llama-gguf \
    --target llama-bench \
    --target llama-ls-sycl-device \
    --target test-backend-ops

# cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' -o -name '*.cpp' -o -name '*.c' -o -name '*.cu?' -o -name '*.hpp' -o -name '*.h' -o -name '*.comp' \) -print -delete

##
## Runtime
##
FROM intel/oneapi-runtime:${ONEAPI_VERSION} AS runtime


RUN apt update

# Install drivers
RUN apt-get install -y \
    intel-opencl-icd \
    intel-level-zero-gpu \
    intel-media-va-driver-non-free

# install utils
RUN apt-get install -y \
    clinfo \
    strace \
    sudo

# Tips https://github.com/microsoft/wslg/issues/531
# ENV XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
# ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=build /home/llamauser/git ./git
COPY --chown=llamauser:llamauser ./src/* ./

# SYCL: Requires access to WSL libs and DRI drivers
# - docker Can't copy drivers from outside the source tree!
# - invalid - COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so /usr/lib/x86_64-linux-gnu/dri
# - invalid - COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_drv_video.so /usr/lib/x86_64-linux-gnu/dri
# - so mount from parent WSL2 instead
VOLUME [ "/usr/lib/wsl" ]
VOLUME [ "/usr/lib/x86_64-linux-gnu/dri" ]

# RUN phase

# SYCL: required for unified memory; set here by default. Broken?
ENV ZES_ENABLE_SYSMAN=1

#
# SYCL: Suggested by https://github.com/intel-analytics/ipex-llm/blob/main/docs/mddocs/Quickstart/llama_cpp_quickstart.md
#
ENV SYCL_CACHE_PERSISTENT=1
# [optional] under most circumstances, the following environment variable may improve performance, but sometimes this may also cause performance degradation
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1
# [optional] if you want to run on single GPU, use below command to limit GPU may improve performance
ENV ONEAPI_DEVICE_SELECTOR=level_zero:0


# lf gets the bin name from LLAMA_SERVER_BIN
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_SERVER_BIN="${LLAMA_PATH}/llama-server"
ENV LLAMA_SERVER_EXTRA_OPTIONS="-ngl 99"

ARG LLAMACPP_VERSION_TAG
ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

RUN echo 'PATH="${LLAMA_PATH}:${PATH}"' >> .bashrc
RUN echo 'PS1="\n(llama.cpp rel $LLAMACPP_VERSION for SYCL)\n$PS1"' >> .bashrc

# Models: mount externally
VOLUME [ "/var/models" ]
EXPOSE 8080

CMD ["/bin/bash","llama-server-start.sh"]
