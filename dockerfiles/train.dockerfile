# Base image
FROM nvidia/cuda:12.6.1-base-ubuntu22.04

# install base python
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     python3 \
#     python3-pip \
#     python3-venv \
#     wget \
#     build-essential \
#     gcc \ 
#     curl && \
#     # Clean up to reduce image size
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# install a specific version of python
RUN apt-get update && \
    apt install --no-install-recommends -y \
    python3.11 \
    python3.11-distutils \
    build-essential \
    gcc curl && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Create a virtual environment and install dependencies inside it
# RUN python3 -m venv venv1

# Install Python 3.11.11 and system dependencies
# RUN . venv1/bin/activate && \
#     apt-get update && \
#     apt-get install --no-install-recommends -y \
#     python3.11 \
#     python3.11-distutils && \
#     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
#     python3.11 get-pip.py && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python3 /usr/bin/python3.11 1     

# Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# set working dicrectory
WORKDIR /mlops

# COPY application,
COPY src/ src/
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt
RUN mkdir models/corruptmnist -p reports/figures/corruptmnist/

# Making share-able volume instead of making copy of data, model and figures
#COPY data/ data/
# Or download fresh data into the container

# Installing source code packges without cache
#RUN pip install -r requirements.txt --no-cache-dir --verbose
#RUN pip install . --no-deps --no-cache-dir --verbose
# Or Use cache in case there're large packages
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

RUN dvc init --no-scm
COPY .dvc/config .dvc/config
COPY data.dvc data.dvc
COPY key/ key/
ENV GOOGLE_APPLICATION_CREDENTIALS="key/gs-service.json"
RUN dvc config core.no_scm true && \
    dvc pull

ENTRYPOINT ["python", "-u", "src/exercise_mlops/train.py"]
