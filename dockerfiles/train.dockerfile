# Base image
#FROM python:3.11-slim AS base
#FROM nvcr.io/nvidia/pytorch:22.12-py3
FROM nvidia/cuda:12.6.1-base-ubuntu22.04

ARG DOCKER_APP=mlops

# RUN apt update && \
#     apt install --no-install-recommends -y build-essential gcc && \
#     apt clean && rm -rf /var/lib/apt/lists/*

# # install
# RUN apt-get update && \
#     apt-get install -y curl python3 python3-pip

# Install Python 3.11.11 and system dependencies
RUN apt update && \
    apt install --no-install-recommends -y \
    python3.11 \
    python3.11-distutils \
    build-essential \
    gcc curl && \
    apt clean && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python3 /usr/bin/python3.11 1     


# Install pip for Python 3.11
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py && \
    rm get-pip.py

# Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# # Upgrade pip before installation
#RUN python -m pip install --upgrade pip


# set working dicrectory
WORKDIR /${DOCKER_APP}

# COPY application,
COPY src/ src/
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt
RUN mkdir models/corruptmnist -p reports/figures/corruptmnist/

# Making shareable volume instead of making copy of data, model and figures
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
