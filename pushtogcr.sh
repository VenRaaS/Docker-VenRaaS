
## init authorize to GCE
docker-credential-gcr configure-docker

SOURCE_IMAGE="venraas/venapi"
IMAGE="venapi"
GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
HOSTNAME="gcr.io"

docker tag $SOURCE_IMAGE $HOSTNAME/$GCP_PROJECT_ID/$IMAGE 

docker push $HOSTNAME/$GCP_PROJECT_ID/$IMAGE

## reference sample
export PROJECT_ID=$(gcloud config list project --format "value(core.project)")
export IMAGE_REPO_NAME=pytorch_custom_container
export IMAGE_TAG=$(date +%Y%m%d_%H%M%S)
export IMAGE_URI=gcr.io/$PROJECT_ID/$IMAGE_REPO_NAME:$IMAGE_TAG

docker build -f Dockerfile -t $IMAGE_URI ./

gcloud auth configure-docker
docker push $IMAGE_URI
