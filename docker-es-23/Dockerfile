FROM ubuntu:18.04
LABEL INSTANCE_TYPE="es-2.3.3"
MAINTAINER robin.rsu@gmail.com

# environment
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
ENV ES_HOME=/home/elk/

RUN groupadd elk
RUN useradd -g elk -m -d $ES_HOME elk

## install elasticsearch
COPY elasticsearch-2.3.3.tar.gz $ES_HOME
WORKDIR $ES_HOME
RUN tar -xvf elasticsearch-2.3.3.tar.gz && \
    rm elasticsearch-2.3.3.tar.gz && \
    chmod 0775 $ES_HOME/elasticsearch-2.3.3    

COPY --chown=elk:root template_hermes.json $ES_HOME/elasticsearch-2.3.3/_template/
COPY --chown=elk:root template_venraas.json $ES_HOME/elasticsearch-2.3.3/_template/

USER elk

ENV vm.max_map_count=262144
ENV ELASTIC_CONTAINER true
ENV ES_HEAP_SIZE=1g

CMD $ES_HOME/elasticsearch-2.3.3/bin/elasticsearch 

