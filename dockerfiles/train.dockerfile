# Base image
#FROM python:3.11-slim AS base
FROM nvcr.io/nvidia/pytorch:22.12-py3

ARG DOCKER_APP=mlops

RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip before installation
RUN python -m pip install --upgrade pip

# set working dicrectory
WORKDIR /${DOCKER_APP}

# COPY application,
COPY src/ src/
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt

# Making shareable volume instead of making copy of data, model and figures
#COPY data/ data/
# Or download fresh data into the container

# Installing source code packges without cache
#RUN pip install -r requirements.txt --no-cache-dir --verbose
#RUN pip install . --no-deps --no-cache-dir --verbose
# Use cache in case there're large packages
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt

ENTRYPOINT ["python", "-u", "src/exercise_mlops/train.py"]
