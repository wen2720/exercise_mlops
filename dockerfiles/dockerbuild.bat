:: build docker image with the command defined in the file, for local development
::docker build -f dockerfiles/train.dockerfile -t corruptmnist:latest .

:: building image for GCP
docker build -f dockerfiles/train.dockerfile -t europe-west4-docker.pkg.dev/dtup-mlop/corruptmnist:latest .

:: --progress=plain option
::docker build --progress=plain -f dockerfiles/train.dockerfile -t corruptmnist:latest .