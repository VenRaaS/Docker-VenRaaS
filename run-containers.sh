

GCP_PROJECT_ID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
## docker run 
image_name="venraas/venapi"
container_name="venapi-1" 
DOMAIN_SUFFIX="venraas.private"
docker run -it -d --name ${container_name} \
    --dns-search $(cat /etc/resolv.conf  | grep -v '^#' | awk '/search /{print $2}') \
    --dns-search "google.internal" --dns-search "$DOMAIN_SUFFIX"  \
    -p 8080:8080 ${image_name} 

image_name="venraas/recapi"
container_name="recapi-1" 
DOMAIN_SUFFIX="venraas.private"
docker run -it -d --name ${container_name} \
    --dns-search $(cat /etc/resolv.conf  | grep -v '^#' | awk '/search /{print $2}') \
    --dns-search "google.internal" --dns-search "$DOMAIN_SUFFIX"  \
    -p 8081:8080 ${image_name} 

image_name="venraas/es-node"
container_name="es-node-01" 
docker run -it -d --name ${container_name} \
    -e "discovery.type=single-node" \
    --ulimit nofile=65535:65535 \
    --ulimit memlock=-1:-1 \
    -v es-data1:/usr/share/elasticsearch/data \
    -p 9200:9200 -p 9300:9300 ${image_name} 

image_name="venraas/hermes"
container_name="hermes-1" 
DOMAIN_SUFFIX="venraas.private"
docker run -it -d --name ${container_name} \
    --ulimit nofile=1024:1024 \
    --ulimit memlock=-1:-1 \
    --dns-search $(cat /etc/resolv.conf  | grep -v '^#' | awk '/search /{print $2}') \
    --dns-search "google.internal" --dns-search "$DOMAIN_SUFFIX"  \
    -p 8082:8080 ${image_name} 



