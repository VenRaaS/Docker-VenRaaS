
## init authorize to GCE
docker-credential-gcr configure-docker

SOURCE_IMAGE="venraas/venapi"
IMAGE="venapi"
GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
HOSTNAME="gcr.io"

docker tag $SOURCE_IMAGE $HOSTNAME/$GCP_PROJECT_ID/$IMAGE 

docker push $HOSTNAME/$GCP_PROJECT_ID/$IMAGE

