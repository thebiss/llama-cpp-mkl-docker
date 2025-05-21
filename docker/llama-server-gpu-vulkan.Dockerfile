##
## Build a llama.cpp instance that uses VULKAN "GPU acceleration"
##

ARG UBUNTU_VERSION=jammy

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
## INIT STAGE
##
FROM ubuntu:$UBUNTU_VERSION AS build


# Install build tools
# add software-properties-common for add-apt-respository
RUN apt update && \
    apt install -y \
        software-properties-common

# Add source for Vulkan SDK
ADD --chmod=444 https://packages.lunarg.com/lunarg-signing-key-pub.asc /tmp/
ADD --chmod=444 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/
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
RUN useradd -m --uid 1010 --groups video llamauser
USER 1010:1010
WORKDIR /home/llamauser

## Pull source
COPY --from=SOURCE --chown=1010:1010 /tmp/git ./git
WORKDIR /home/llamauser/git

# Make
RUN cmake -B build -DGGML_NATIVE=OFF -DGGML_VULKAN=1

RUN cmake --build build -j $(nproc) \
    --config Release
    
# cleanup ahead of the runtime copy
## RUN find ./ \( -name '*.o' \) -delete    

##
## RUNTIME 
##
# FROM same image - no new image

WORKDIR /home/llamauser
COPY --chown=llamauser:llamauser ./src/* ./

## Run phase
ENV LLAMA_PATH="/home/llamauser/git/build/bin"
ENV LLAMA_ARG_N_GPU_LAYERS="33"

ARG LLAMA_CPP_VERSION_TAG
ENV LLAMA_CPP_VERSION=${LLAMA_CPP_VERSION_TAG}

ENV LLAMA_BUILDER="Vulkan"


# mount models externally

VOLUME [ "/var/models" ]
EXPOSE 8080

# Run the command in a login shell
CMD ["/bin/bash","--login","-i","-c","/home/llamauser/llama-server-start.sh"]

