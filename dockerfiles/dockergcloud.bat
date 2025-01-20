::build docker image and push to gcloudy
gcloud builds submit --config=%cd%/dockerfiles/cloudbuild.yaml .