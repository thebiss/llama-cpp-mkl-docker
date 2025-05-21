##
## Build a llama.cpp instance that uses Intel One MKL CPU acceleration
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

# 10 April - Latest OpenAPI doesn't have libcurl
RUN apt-get update && apt-get -y install libcurl4-openssl-dev

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=SOURCE --chown=1010:1010 /tmp/git ./git
WORKDIR /home/llamauser/git

# Make
RUN cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=Intel10_64lp -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_NATIVE=ON

RUN cmake --build build -j $(nproc) \
    --config Release

## cleanup ahead of the runtime copy
RUN find ./ \( -name '*.o' \) -delete



##
## Runtime
##
FROM intel/oneapi-runtime:${ONEAPI_VERSION} AS runtime

RUN useradd -m --uid 1010 llamauser
USER 1010:1010
WORKDIR /home/llamauser

COPY --from=build /home/llamauser/git ./git
COPY --chown=llamauser:llamauser ./src/* ./

## Run phase

ENV LLAMA_PATH="/home/llamauser/git/build/bin"

ARG LLAMA_CPP_VERSION_TAG
ENV LLAMA_CPP_VERSION=${LLAMA_CPP_VERSION_TAG}

ENV LLAMA_BUILDER="Intel OneMKL"



# mount models externally

VOLUME [ "/var/models" ]
EXPOSE 8080

# Run the command in a login shell
CMD ["/bin/bash","--login","-i","-c","/home/llamauser/llama-server-start.sh"]
