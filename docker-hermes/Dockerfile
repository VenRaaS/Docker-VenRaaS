FROM ubuntu:18.04
LABEL INSTANCE_TYPE="hermes"
MAINTAINER robin.rsu@gmail.com

RUN apt-get update && \
    apt-get -y install sudo wget curl && \
    apt-get clean
## install openJDK
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk && \
    apt-get clean

## Change TimeZone
ENV TZ="Asia/Taipei"
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install tzdata && \
    apt-get clean
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENV TOMCAT_VERSION 8.5.50
ENV CATALINA_HOME /opt/tomcat
RUN mkdir -p "$CATALINA_HOME"

WORKDIR $CATALINA_HOME
RUN curl -O RUN curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz
RUN tar xvfz apache*.tar.gz && \
    mv apache-tomcat-8.5.51/* $CATALINA_HOME/.
RUN rm -rf $CATALINA_HOME/webapps/docs/; \
    rm -rf $CATALINA_HOME/webapps/examples/; \
    rm -rf $CATALINA_HOME/webapps/host-manager/; \
    rm -rf $CATALINA_HOME/webapps/manager/; \
    rm -rf $CATALINA_HOME/webapps/ROOT/;
## install venapis.war
COPY hermes.war $CATALINA_HOME/webapps

EXPOSE 8080

# Ubuntu packages
RUN apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

CMD $CATALINA_HOME/bin/catalina.sh run;

HEALTHCHECK --interval=10m --timeout=3s \
  CMD curl -f http://localhost:8080/hermes/health|| exit 1

