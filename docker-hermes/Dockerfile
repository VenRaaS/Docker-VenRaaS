FROM ubuntu:18.04
LABEL INSTANCE_TYPE="hermes"
MAINTAINER robin.rsu@gmail.com

RUN apt-get update && \
    apt-get -y install sudo wget curl
## install openJDK
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk

# environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install tzdata
ENV TZ="Asia/Taipei"
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV TOMCAT_VERSION 8.5.50
ENV CATALINA_HOME /opt/tomcat
RUN mkdir -p "$CATALINA_HOME"

WORKDIR $CATALINA_HOME
RUN curl -O http://apache.stu.edu.tw/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz
RUN tar xvfz apache*.tar.gz && \
    mv apache-tomcat-8.5.50/* $CATALINA_HOME/.
RUN rm -rf $CATALINA_HOME/webapps/docs/; \
    rm -rf $CATALINA_HOME/webapps/examples/; \
    rm -rf $CATALINA_HOME/webapps/host-manager/; \
    rm -rf $CATALINA_HOME/webapps/manager/; \
    rm -rf $CATALINA_HOME/webapps/ROOT/;
## install venapis.war
COPY hermes.war $CATALINA_HOME/webapps

EXPOSE 8080

ARG PROJECT_ID

# Ubuntu packages
RUN apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

## install elasticsearch
RUN groupadd -g 1000 elk && \
    adduser --uid 1000 --gid 1000 --home /home/elk --disabled-password --gecos '' elk 
COPY elasticsearch-2.3.3.tar.gz /home/elk/
WORKDIR /home/elk/
RUN tar -xvf elasticsearch-2.3.3.tar.gz && \
    rm elasticsearch-2.3.3.tar.gz && \
    chmod 0775 /home/elk/elasticsearch-2.3.3    
COPY elasticsearch.yml /home/elk/elasticsearch-2.3.3/config/

ENV ELASTIC_CONTAINER true
ENV ES_HEAP_SIZE=1g

EXPOSE 9200 9300

USER root

CMD export ES_HEAP_SIZE=1g;  /home/elk/elasticsearch-2.3.3/bin/elasticsearch -d; \ 
    $CATALINA_HOME/bin/catalina.sh run;

