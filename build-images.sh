
GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
## build docker image
image_name="venraas/venapi"
docker build -t ${image_name}  . \
    --build-arg PROJECT_ID="$GCP_PROJECT_ID"

GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
## build docker image
image_name="venraas/recapi"
docker build -t ${image_name}  . \
    --build-arg PROJECT_ID="$GCP_PROJECT_ID"

## build docker image
image_name="venraas/es-node"
docker build -t ${image_name}  .

GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
## build docker image 
image_name="venraas/es-23"
docker build -t ${image_name}  . \
    --build-arg PROJECT_ID="$GCP_PROJECT_ID"

GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
## build docker image
image_name="venraas/hermes"
docker build -t ${image_name}  . \
    --build-arg PROJECT_ID="$GCP_PROJECT_ID"




