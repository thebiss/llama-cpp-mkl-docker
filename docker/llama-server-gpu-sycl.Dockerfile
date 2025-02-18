##
## Build a llama.cpp instance that uses Intel SYCL GPU acceleration
##
ARG ONEAPI_VERSION=2025.0.1-0-devel-ubuntu22.04

##
## Build Stage
##
FROM intel/oneapi-basekit:${ONEAPI_VERSION} AS build

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

ARG LLAMACPP_VERSION_TAG
RUN if [ -z "$LLAMACPP_VERSION_TAG" ]; then echo "Error: arg LLAMACPP_VERSION_TAG must be set." && exit 1; fi

ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

# Fetch from repo
# ADD --chown=1010:1010 https://github.com/ggml-org/llama.cpp.git#${LLAMACPP_VERSION_TAG} git
# podman buildah doesn't support GIT URL special handling
RUN git clone -c advice.detachedHead=false -q --depth 1 --branch ${LLAMACPP_VERSION_TAG} https://github.com/ggml-org/llama.cpp.git git
WORKDIR /home/llamauser/git

## Added tiger lake device architecture.  very machine specific.
# 19 Jan - removed due to warnings they were unused: -DGGML_CYCL_DEVICE_ARCH=tgl -DGGML_SYCL_DEBUG=ON 
RUN cmake -B build -DGGML_SYCL=ON -DGGML_SYCL_TARGET=INTEL -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_SYCL_F16=ON

RUN cmake --build build -j $(nproc) \
    --config Release
    
## Make all targets
#     \
#    --target llama-server \
#    --target llama-gguf \
#    --target llama-bench \
#    --target llama-ls-sycl-device \
#    --target test-backend-ops \
#    --target llama-cli


## cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' \) -print -delete
# -o -name '*.cpp' -o -name '*.c' -o -name '*.cu?' -o -name '*.hpp' -o -name '*.h' -o -name '*.comp' 

##
## Runtime
##
# FROM intel/oneapi-runtime:${ONEAPI_VERSION} AS runtime
FROM intel/oneapi-basekit:${ONEAPI_VERSION} AS runtime

RUN apt update

# Install drivers
RUN apt-get install -y \
    intel-opencl-icd \
    intel-media-va-driver-non-free
#    intel-level-zero-gpu

# install utils
RUN apt-get install -y \
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
ENV SYCL_PI_LEVEL_ZERO_USE_IMMEDIATE_COMMANDLISTS=1


# lf gets the bin name from LLAMA_SERVER_BIN
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_SERVER_BIN="${LLAMA_PATH}/llama-server"
ENV LLAMA_ARG_N_GPU_LAYERS="99"

ARG LLAMACPP_VERSION_TAG
ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

RUN echo 'PATH="${LLAMA_PATH}:${PATH}"' >> .bashrc
RUN echo 'PS1="\n(llama.cpp rel $LLAMACPP_VERSION for SYCL)\n$PS1"' >> .bashrc

# Models: mount externally
ENV _MODELHOME="/var/models"
VOLUME [ "${_MODELHOME}" ]
EXPOSE 8080

CMD ["/bin/bash","llama-server-start.sh"]
