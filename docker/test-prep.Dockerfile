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
    software-properties-common

# Add source for Vulkan SDK and cURL
ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/
ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/

# Add source for Update MESA using the PPA to fix driver issue
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
RUN add-apt-repository ppa:kisak/kisak-mesa 

# Update indexes, upgrade drivers
RUN apt update -y 

# Install build tools
RUN apt install -y \
        git \
        build-essential \
        cmake 

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

COPY llama-server-start.sh gpuinfo.sh ./

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash"]
