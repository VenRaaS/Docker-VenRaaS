FROM ubuntu:18.04
LABEL INSTANCE_TYPE="es-2.3.3"
MAINTAINER robin.rsu@gmail.com

## Change TimeZone
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install tzdata && \
    apt-get clean    
ENV TZ="Asia/Taipei"
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN dpkg-reconfigure --frontend noninteractive tzdata

## install openJDK
RUN apt-get update && \
    apt-get -y install sudo wget curl vim && \
    apt-get -y install openjdk-8-jdk && \
    apt-get clean

ENV ES_VERSION=2.3.3
ENV ES_HOME=/home/elk
ENV cluster.name=hermes-cluster

RUN groupadd -g 1000 elk && \
    adduser --uid 1000 --gid 1000 --home /home/elk --disabled-password --gecos '' elk     

## install elasticsearch
COPY elasticsearch-2.3.3.tar.gz $ES_HOME
WORKDIR $ES_HOME
RUN tar -xvf elasticsearch-2.3.3.tar.gz && \
    rm elasticsearch-2.3.3.tar.gz && \
    chmod 0775 $ES_HOME/elasticsearch-2.3.3    

RUN rm $ES_HOME/elasticsearch-2.3.3/config/elasticsearch.yml 
COPY --chown=elk:root template_hermes.json $ES_HOME/elasticsearch-2.3.3/_template/
COPY --chown=elk:root template_venraas.json $ES_HOME/elasticsearch-2.3.3/_template/

#RUN sudo sysctl -w vm.max_map_count=262144
RUN echo "cluster.name: hermes-cluster" >> $ES_HOME/elasticsearch-2.3.3/config/elasticsearch.yml
RUN echo "network.host: 0.0.0.0" >> $ES_HOME/elasticsearch-2.3.3/config/elasticsearch.yml
#RUN echo "index.query.bool.max_clause_count: 16384" >> $ES_HOME/elasticsearch-2.3.3/config/elasticsearch.yml
#RUN echo "index.max_result_window: 2147483647" >> $ES_HOME/elasticsearch-2.3.3/config/elasticsearch.yml

# https://www.elastic.co/guide/en/elasticsearch/reference/6.8/docker.html
# chmod g+rwx $ES_DATA && chgrp 1000 $ES_DATA
ENV ES_DATA $ES_HOME/elasticsearch-2.3.3/data
VOLUME $ES_DATA
# RUN chown -R elk:elk "$ES_DATA" && chmod 777 "$ES_DATA"

EXPOSE 9200 9300-9400

USER elk

ENV bootstrap.memory_lock=true
ENV ELASTIC_CONTAINER true
ENV ES_HEAP_SIZE=1g

ENTRYPOINT $ES_HOME/elasticsearch-2.3.3/bin/elasticsearch 

HEALTHCHECK --interval=10m --timeout=3s \
  CMD curl -f http://localhost:9200/_cat/health || exit 1

