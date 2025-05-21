##
## Build a llama.cpp instance that uses Intel SYCL GPU acceleration
##
ARG ONEAPI_VERSION=2025.1.1-0-devel-ubuntu24.04


##
## Fetch stage
##
FROM alpine:latest as SOURCE
RUN apk add --no-cache git

ARG LLAMA_CPP_VERSION_TAG
ENV LLAMA_CPP_VERSION=${LLAMA_CPP_VERSION_TAG}
RUN if [ -z "$LLAMA_CPP_VERSION_TAG" ]; then echo "Error: arg LLAMA_CPP_VERSION_TAG must be set." && exit 1; fi

# Fetch from repo
# ADD --chown=1010:1010 https://github.com/ggml-org/llama.cpp.git#${LLAMA_CPP_VERSION_TAG} git
# podman buildah doesn't support GIT URL special handling
RUN cd /tmp && \
    git clone -c advice.detachedHead=false -q --depth 1 --branch ${LLAMA_CPP_VERSION_TAG} https://github.com/ggml-org/llama.cpp.git git



##
## Build Stage
##
FROM intel/oneapi-basekit:${ONEAPI_VERSION} AS build

RUN apt-get update && apt-get -y install libcurl4-openssl-dev

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=SOURCE --chown=1010:1010 /tmp/git ./git
WORKDIR /home/llamauser/git

# Make
# 17 May 2025 - Updated to align with latest devops docker file CLI
RUN cmake -B build -DGGML_NATIVE=OFF -DGGML_SYCL=ON \
    -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx \
    -DGGML_BACKEND_DL=ON -DGGML_CPU_ALL_VARIANTS=ON -DGGML_SYCL_F16=ON

RUN cmake --build build -j $(nproc) \
    --config Release
    
# cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' \) -delete

##
## Runtime
##
# FROM intel/oneapi-runtime:${ONEAPI_VERSION} AS runtime
FROM intel/oneapi-basekit:${ONEAPI_VERSION} AS runtime


# Install drivers
# Install Utils
RUN apt-get update && apt-get install -y \
    intel-opencl-icd \
    intel-media-va-driver-non-free \
    clinfo \
    strace \
    sudo

# Tips https://github.com/microsoft/wslg/issues/531
# ENV XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
# ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN useradd -m --uid 1010 --groups video llamauser
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
# ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1


# lf gets the bin name from LLAMA_CPP_BIN
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_ARG_N_GPU_LAYERS="99"

ARG LLAMA_CPP_VERSION_TAG
ENV LLAMA_CPP_VERSION=${LLAMA_CPP_VERSION_TAG}

ENV LLAMA_BUILDER="SYCL"


# Models: mount externally

VOLUME [ "/var/models" ]
EXPOSE 8080

# Run the command in a login shell
CMD ["/bin/bash","--login","-i","-c","/home/llamauser/llama-server-start.sh"]

