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
WORKDIR git

# You can skip this step if  in oneapi-basekit docker image, only required for manual installation
# source /opt/intel/oneapi/setvars.sh 
RUN cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=Intel10_64lp -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_NATIVE=ON

# make only the server target
# 23 Sept - run parallel
RUN cmake --build build --config Release --target llama-server -j

# cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' -o -name '*.cpp' -o -name '*.c' -o -name '*.cu?' -o -name '*.hpp' -o -name '*.h' -o -name '*.comp' \) -print -delete

##
## Runtime
##
FROM intel/oneapi-runtime:${ONEAPI_IMAGE_VER} AS runtime

# Update GPU repo
# RUN apt-get install -y gpg-agent wget
# RUN wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | \
#     gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
# RUN echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy arc' | \
#     tee  /etc/apt/sources.list.d/intel.gpu.jammy.list

RUN apt update

# # Install drivers
RUN apt-get install -y \
    intel-opencl-icd \
    intel-level-zero-gpu \
    intel-media-va-driver-non-free \
    level-zero \
    libegl-mesa0 \
    libegl1-mesa \
    libgbm1 \
    libgl1-amber-dri \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libglapi-mesa \
    libglu1-mesa \
    libglx-mesa0 \
    libigdgmm12 \
    libmfx1 \
    libmfxgen1 \
    libvpl2 \
    libxatracker2 \
    mesa-va-drivers \
    mesa-vdpau-drivers \
    mesa-vulkan-drivers \
    mesa-utils-bin \
    mesa-utils \
    va-driver-all \
    vdpau-driver-all

## Install development files - not needed
# RUN apt-get install -y \
#     libegl1-mesa-dev \    
#     libgl1-mesa-dev \
#     libgles2-mesa-dev

# install utils
RUN apt-get install -y \
    clinfo \
    strace \
    vainfo \
    sudo 


# Tips https://github.com/microsoft/wslg/issues/531
# ENV XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir
# ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib


# Copy the missing drivers
# can't copy files from outside the source tree!
## COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_dri.so /usr/lib/x86_64-linux-gnu/dri
## COPY /usr/lib/x86_64-linux-gnu/dri/d3d12_drv_video.so /usr/lib/x86_64-linux-gnu/dri


RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=build /home/llamauser/git ./git

COPY llama-server-start.sh gpuinfo.sh ./
ENV LLAMA_SERVER_BIN=/home/llamauser/git/build/bin/llama-server

## Run phase

# mount models externally
VOLUME [ "/var/models" ]
EXPOSE 8080

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash","/home/llamauser/llama-server-start.sh"]
