::%cd%/dockerfiles/dockerbuild.bat

:: --progress=plain option
::docker build --progress=plain -f dockerfiles/train.dockerfile -t corruptmnist:latest .

::1. local, build docker image with the command defined in the file, for local development
docker build -f dockerfiles/train.dockerfile -t corruptmnist:latest .

::2. remote, building image for GCP
::docker build -f dockerfiles/train.dockerfile -t europe-west4-docker.pkg.dev/dtup-mlop/corruptmnist/corruptmnist:latest .
