docker build -f dockerfiles/train.dockerfile -t corruptmnist:latest .
::docker build --progress=plain -f dockerfiles/train.dockerfile -t corruptmnist:latest .
::docker build -f dockerfiles/train.dockerfile -t train:latest .