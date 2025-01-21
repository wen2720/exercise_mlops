::gcr.io docker submit build and push step 
docker tag corruptmnist:latest europe-west4-docker.pkg.dev/dtup-mlop/corruptmnist/corruptmnist:latest
gcloud builds submit --config=cloudbuild.yaml .