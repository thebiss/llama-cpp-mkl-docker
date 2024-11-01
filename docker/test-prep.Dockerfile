#
# From the llama.cpp folder, with tweaks
#

ARG UBUNTU_VERSION=jammy

##
## BUILD STAGE
##
FROM ubuntu:$UBUNTU_VERSION AS build

# Update Ubuntu base to let APT cache data!
# subsequent lines will use the apt cache volume
# thanks to: https://stackoverflow.com/questions/24372792/how-to-preserve-apt-cache-archive-directory-when-using-docker-host-volumes
RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN touch /var/touchedfile

# Install build tools
# add software-properties-common for add-apt-respository
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y && \
    apt install -y \
    software-properties-common

# Add source for Vulkan SDK and cURL
ADD --chmod=644 https://packages.lunarg.com/vulkan/lunarg-vulkan-jammy.list /etc/apt/sources.list.d/
ADD --chmod=644 https://packages.lunarg.com/lunarg-signing-key-pub.asc /etc/apt/trusted.gpg.d/

# Add source for Update MESA using the PPA to fix driver issue
# https://github.com/microsoft/wslg/issues/40#issuecomment-2037539322
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    add-apt-repository ppa:kisak/kisak-mesa 

# Update indexes, upgrade drivers
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y 

# Install build tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt install -y \
        git \
        build-essential \
        cmake 

# Install Vulkan SDK and CURL 
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
        vulkan-sdk \
        libcurl4-openssl-dev \
        curl \
        pciutils \
        vulkan-tools \
        mesa-utils

# Install diagnostic utils
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
        clinfo \
        strace \
        vainfo \
        sudo 

COPY llama-server-start.sh gpuinfo.sh ./

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash"]
