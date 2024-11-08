##
## Build a llama.cpp instance that uses VULKAN "GPU acceleration"
##

ARG UBUNTU_VERSION=jammy

##
## INIT STAGE
##
FROM ubuntu:$UBUNTU_VERSION AS build


# Install build tools
# add software-properties-common for add-apt-respository
RUN apt update && \
    apt install -y \
        software-properties-common

# Add source for Vulkan SDK
ADD https://packages.lunarg.com/lunarg-signing-key-pub.asc /tmp/
ADD https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/
RUN apt-key add /tmp/lunarg-signing-key-pub.asc

# Add source for Update MESA using the PPA to fix driver issue
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
RUN add-apt-repository ppa:kisak/kisak-mesa 

# Update indexes, upgrade drivers
RUN apt update 

# Install build & diagnostic tools
RUN apt-get install -y \
        git \
        build-essential \
        cmake \
        wget \
        curl \
        strace \
        sudo 

# Install Vulkan SDK and CURL 
RUN apt-get install -y \
        vulkan-sdk \
        vulkan-tools \
        libcurl4-openssl-dev \
        pciutils \
        mesa-utils \
        vainfo    

##
## BUILD STAGE
##

# FROM - not used, same image as above
        
## Add user
RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

## Pull source
ARG LLAMACPP_VERSION_TAG
RUN if [ -z "$LLAMACPP_VERSION_TAG" ]; then \
    echo "Error: arg LLAMACPP_VERSION_TAG must be set." && exit 1; \
    fi

ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

# Fetch from repo
ADD --chown=1010:1010 --keep-git-dir=true https://github.com/ggerganov/llama.cpp.git#${LLAMACPP_VERSION_TAG} git
WORKDIR /home/llamauser/git


# Build it
RUN cmake -B build -DGGML_VULKAN=1 -DLLAMA_CURL=1 

RUN cmake --build build -j 6 \
    --config Release \
    --target llama-server \
    --target llama-gguf \
    --target llama-bench \
    --target test-backend-ops

# cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' -o -name '*.cpp' -o -name '*.c' -o -name '*.cu?' -o -name '*.hpp' -o -name '*.h' -o -name '*.comp' \) -print -delete


##
## RUNTIME 
##
# FROM same image - no new image

WORKDIR /home/llamauser
COPY --chown=llamauser:llamauser ./src/* ./

## Run phase
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_SERVER_BIN="${LLAMA_PATH}/llama-server"
ENV LLAMA_SERVER_EXTRA_OPTIONS="-ngl 99"

RUN echo 'PATH="${LLAMA_PATH}:${PATH}"' >> .bashrc

# mount models externally
VOLUME [ "/var/models" ]
EXPOSE 8080

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash","llama-server-start.sh"]
