FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

ARG SD_SCRIPTS_VERSION
ARG TORCH_VERSION
ARG TORCHVISION_VERSION
ARG XFORMERS_VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV SHELL=/bin/bash
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu
ENV PATH="/workspace/venv/bin:$PATH"

WORKDIR /workspace

# Set up shell and update packages
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install system dependencies
RUN apt update --yes && \
    apt upgrade --yes && \
    apt install --yes --no-install-recommends \
    git openssh-server libglib2.0-0 libsm6 libgl1 libxrender1 libxext6 ffmpeg wget curl psmisc rsync vim bc nginx \
    pkg-config libffi-dev libcairo2 libcairo2-dev libgoogle-perftools4 libtcmalloc-minimal4 apt-transport-https \
    software-properties-common ca-certificates && \
    update-ca-certificates

# Install Python 3.10
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3.10-dev python3.10-venv -y --no-install-recommends && \
    ln -s /usr/bin/python3.10 /usr/bin/python && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.10 /usr/bin/python3 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \python get-pip.py && \
    pip install -U --no-cache-dir pip

# Install additional packages
RUN apt install --yes --no-install-recommends \
    bash dos2unix net-tools htop screen tmux zip unzip p7zip-full

# Clean up
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

# Set locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# # Cache Models
# RUN mkdir /sd-models && \
#     wget https://huggingface.co/Airic/Anything-V4.5/resolve/main/Anything-v4.5-pruned-mergedVae.safetensors -O /sd-models/Anything-v4.5-pruned-mergedVae.safetensors && \
#     wget https://huggingface.co/cagliostrolab/animagine-xl-3.1/resolve/main/animagine-xl-3.1.safetensors -O /sd-models/animagine-xl-3.1.safetensors

# Install Jupyter Lab
RUN pip install -U --no-cache-dir jupyterlab jupyterlab_widgets ipykernel ipywidgets

# Install kohya_ss's sd-scripts
RUN git clone https://github.com/kohya-ss/sd-scripts.git && \
    cd sd-scripts && \
    git checkout tags/${SD_SCRIPTS_VERSION} && \
    pip install --no-cache-dir torch===${TORCH_VERSION} torchvision===${TORCHVISION_VERSION} --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir pip install albumentations==1.3.0 gradio==3.16.2 requests==2.28.2 timm==0.6.12 fairscale==0.4.13 onnx==1.15.0 onnxruntime-gpu==1.17.1 onnxruntime==1.17.1 protobuf==3.20.3 open-clip-torch==2.20.0 && \
    pip install --no-cache-dir xformers==${XFORMERS_VERSION} --index-url https://download.pytorch.org/whl/cu118 && \
    pip install --no-cache-dir wandb tensorboard

# NGINX Proxy
COPY --from=proxy nginx.conf /etc/nginx/nginx.conf
COPY --from=proxy readme.html /usr/share/nginx/html/readme.html

# Copy the README.md
COPY README.md /usr/share/nginx/html/README.md

# Start Scripts
COPY --from=scripts start.sh /
RUN chmod +x /start.sh

SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
