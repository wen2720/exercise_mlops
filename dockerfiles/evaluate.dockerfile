# Base image
FROM python:3.11-slim AS base

RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip before installation
RUN python -m pip install --upgrade pip

# COPY application
COPY src/ src/
COPY data/ data/
COPY requirements.txt requirements.txt
COPY requirements_dev.txt requirements_dev.txt
#COPY README.md README.md
COPY pyproject.toml pyproject.toml
# Create path for saving models and figures

# set working dicrectory
WORKDIR /

#RUN pip install -r requirements.txt --no-cache-dir --verbose
#Use cache in case there're large packages
RUN --mount=type=cache,target=/root/.cache/pip pip install -r requirements.txt
RUN pip install . --no-deps --no-cache-dir --verbose

ENTRYPOINT ["python", "-u", "src/exercise_mlops/evaluate.py"]
