#
# From the llama.cpp folder, with tweaks
#

ARG UBUNTU_VERSION=jammy

##
## BUILD STAGE
##
FROM ubuntu:$UBUNTU_VERSION AS build


# Install build tools
# add software-properties-common for add-apt-respository
RUN apt update && \
    apt install -y \
        git \
        build-essential \
        cmake \
        wget \
        software-properties-common

        # Add source for Vulkan SDK and cURL
RUN wget -qO - https://packages.lunarg.com/lunarg-signing-key-pub.asc | apt-key add - && \
wget -qO /etc/apt/sources.list.d/lunarg-vulkan-jammy.list https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list 

# Add source for Update MESA using the PPA to fix driver issue
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
RUN add-apt-repository ppa:kisak/kisak-mesa 

# Update indexes, upgrade drivers
RUN apt update -y && \
    apt upgrade -y


# Install Vulkan SDK and CURL 
RUN apt-get install -y \
        vulkan-sdk \
        libcurl4-openssl-dev \
        curl \
        pciutils \
        vulkan-tools \
        mesa-utils

# Install diagnostic utils
RUN apt-get install -y \
        clinfo \
        strace \
        vainfo \
        sudo 



        
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
WORKDIR git


# Build it
# WORKDIR /app
# COPY . .
RUN cmake -B build -DGGML_VULKAN=1 -DLLAMA_CURL=1 && \
    cmake --build build --config Release --target llama-server -j 6

# Clean up

##
## RUNTIME 
##



# FROM same image - no new image
WORKDIR /home/llamauser

COPY llama-server-start.sh gpuinfo.sh ./
ENV LLAMA_SERVER_BIN=/home/llamauser/git/build/bin/llama-server

## Run phase

# mount models externally
VOLUME [ "/var/models" ]
EXPOSE 8080

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash","/home/llamauser/llama-server-start.sh"]


# ENV LC_ALL=C.utf8
# # Must be set to 0.0.0.0 so it can listen to requests from host machine
# ENV LLAMA_ARG_HOST=0.0.0.0

# HEALTHCHECK CMD [ "curl", "-f", "http://localhost:8080/health" ]

# ENTRYPOINT [ "/llama-server" ]
