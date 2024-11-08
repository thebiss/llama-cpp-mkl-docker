#
# docker build -t bbissell/llama-cpp-mkl:b3467
#

ARG  ONEAPI_IMAGE_VER=2024.2.1-0-devel-ubuntu22.04

##
## Build Stage
##
FROM intel/oneapi-basekit:${ONEAPI_IMAGE_VER} AS build

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
RUN cmake -B build -DGGML_SYCL=ON -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_SYCL_F16=ON

# make only the server target
# 23 Sept - run parallel
RUN cmake --build build -j 6 \
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
FROM intel/oneapi-runtime:${ONEAPI_IMAGE_VER} AS runtime


RUN apt update

# Install drivers
RUN apt-get install -y \
    intel-opencl-icd \
    intel-level-zero-gpu \
    intel-media-va-driver-non-free

# 7 Nov 2024 - Don't need OpenGL or MESA, or video acceleration drivers
    # level-zero \
    # libegl-mesa0 \
    # libegl1-mesa \
    # libgbm1 \
    # libgl1-amber-dri \
    # libgl1-mesa-dri \
    # libgl1-mesa-glx \
    # libglapi-mesa \
    # libglu1-mesa \
    # libglx-mesa0 \
    # libigdgmm12 \
    # libmfx1 \
    # libmfxgen1 \
    # libvpl2 \
    # libxatracker2 \
    # mesa-va-drivers \
    # mesa-vdpau-drivers \
    # mesa-vulkan-drivers \
    # mesa-utils-bin \
    # mesa-utils \
    # va-driver-all \
    # vdpau-driver-all

# RUN apt-get install -y \
#     libegl1-mesa-dev \    
#     libgl1-mesa-dev \
#     libgles2-mesa-dev

# install utils
RUN apt-get install -y \
    clinfo \
    strace \
    sudo
#    vainfo \

# Tips https://github.com/microsoft/wslg/issues/531
# ENV XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
# ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib



RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=build /home/llamauser/git ./git
COPY --chown=llamauser:llamauser ./src/* ./

# Can't copy drivers from outside the source tree!
# COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so /usr/lib/x86_64-linux-gnu/dri
# COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_drv_video.so /usr/lib/x86_64-linux-gnu/dri

# SYCL: required for unified memory; set here by default. Broken?
ENV ZES_ENABLE_SYSMAN=1

# SYCL: Requires access to WSL libs and DRI drivers
VOLUME [ "/usr/lib/wsl" ]
VOLUME [ "/usr/lib/x86_64-linux-gnu/dri" ]

# RUN phase
# lf gets the bin name from LLAMA_SERVER_BIN
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_SERVER_BIN="/home/llamauser/git/build/bin/llama-server"
ENV LLAMA_SERVER_EXTRA_OPTIONS="-ngl 33"

# Models: mount externally
VOLUME [ "/var/models" ]

EXPOSE 8080

CMD ["/bin/bash","/home/llamauser/llama-server-start.sh"]
