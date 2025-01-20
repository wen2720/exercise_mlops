::docker run --rm -it -v %cd%/data:/data/ -v %cd%/models:/models/ train:latest
::docker run --rm --gpus all -it train:latest
::docker run --gpus all -it corruptmnist:latest
::docker run --rm -it --entrypoint sh corruptmnist:latest
::docker run --rm -it --entrypoint sh nvcr.io/nvidia/pytorch:24.09-py3
docker run --gpus all -it corruptmnist:latest