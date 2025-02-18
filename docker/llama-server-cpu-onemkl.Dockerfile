##
## Build a llama.cpp instance that uses Intel One MKL CPU acceleration
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

# You can skip this step if  in oneapi-basekit docker image, only required for manual installation
# source /opt/intel/oneapi/setvars.sh 
RUN cmake -B build -DGGML_BLAS=ON -DGGML_BLAS_VENDOR=Intel10_64lp -DCMAKE_C_COMPILER=icx -DCMAKE_CXX_COMPILER=icpx -DGGML_NATIVE=ON

RUN cmake --build build -j $(nproc) \
    --config Release

## now make all    
#     \
#    --target llama-server \
#    --target llama-gguf \
#    --target llama-bench \
#    --target test-backend-ops \
#    --target llama-cli


## cleanup ahead of the runtime copy
# RUN find ./ \( -name '*.o' -o -name '*.cpp' -o -name '*.c' -o -name '*.cu?' -o -name '*.hpp' -o -name '*.h' -o -name '*.comp' \) -print -delete
RUN find ./ \( -name '*.o' \) -print -delete

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
ENV LLAMA_SERVER_BIN="${LLAMA_PATH}/llama-server"

ARG LLAMACPP_VERSION_TAG
ENV LLAMACPP_VERSION=${LLAMACPP_VERSION_TAG}

RUN echo 'PATH="${LLAMA_PATH}:${PATH}"' >> .bashrc
RUN echo 'PS1="\n(llama.cpp rel $LLAMACPP_VERSION with OneAPI MKL)\n$PS1"' >> .bashrc

# mount models externally
ENV _MODELHOME="/var/models"
VOLUME [ "${_MODELHOME}" ]
EXPOSE 8080

# lf gets the bin name from LLAMA_SERVER_BIN
CMD ["/bin/bash","llama-server-start.sh"]
