

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

image_name="venraas/es-23"
container_name="es-233"
ES_DATA="/media/es-data1"
chmod g+rwx $ES_DATA
chown 1000 -R $ES_DATA
chgrp 1000 -R $ES_DATA
docker run -it -d --name ${container_name} \
    -e "discovery.type=single-node" \
    --ulimit nofile=65535:65535 \
    --ulimit memlock=-1:-1 \
    -v /media/es-data1:/home/elk/elasticsearch-2.3.3/data \
    -p 9200:9200 -p 9300-9400:9300-9400 ${image_name}

image_name="venraas/postgres:9.3"
container_name="postgresql-1"
docker run -it -d --name ${container_name} \
    -e PGDATA=/media/postgres-data \
    -v /media/postgres-data/main:/media/postgres-data \
    -p 5432:5432 ${image_name}

image_name="venraas/hermes"
container_name="hermes-1" 
DOMAIN_SUFFIX="venraas.private"
docker run -it -d --name ${container_name} \
    --ulimit nofile=1024:1024 \
    --ulimit memlock=-1:-1 \
    --dns-search $(cat /etc/resolv.conf  | grep -v '^#' | awk '/search /{print $2}') \
    --dns-search "google.internal" --dns-search "$DOMAIN_SUFFIX"  \
    -p 8082:8080 ${image_name} 



