FROM ubuntu:18.04
LABEL INSTANCE_TYPE="raas-pv"
MAINTAINER chsteven@gmail.com

RUN apt-get update && \
    apt-get -y install sudo wget curl && \
    apt-get clean
## install openJDK
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk && \
    apt-get clean
## install Python
RUN apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && ln -s /usr/bin/pip3 pip \
    && pip3 install --upgrade pip \
    && apt-get clean

# environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install tzdata
ENV TZ="Asia/Taipei"
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN useradd -ms /bin/bash tomcat

ENV TOMCAT_VERSION 7.0.99
ENV CATALINA_HOME /opt/tomcat
RUN mkdir -p "$CATALINA_HOME"

WORKDIR $CATALINA_HOME
RUN curl -O http://ftp.tc.edu.tw/pub/Apache/tomcat/tomcat-7/v7.0.99/bin/apache-tomcat-7.0.99.tar.gz
COPY apache-tomcat-7.0.99.tar.gz $CATALINA_HOME
RUN tar xvfz apache*.tar.gz && \
    mv apache-tomcat-7.0.99/* $CATALINA_HOME/.
RUN rm -rf $CATALINA_HOME/webapps/docs/; \
    rm -rf $CATALINA_HOME/webapps/examples/; \
    rm -rf $CATALINA_HOME/webapps/host-manager/; \
    rm -rf $CATALINA_HOME/webapps/manager/; \
    rm -rf $CATALINA_HOME/webapps/ROOT/;
## install raas.war
COPY raas.war $CATALINA_HOME/webapps/

## copy jar files for raas
COPY abTest.jar $CATALINA_HOME/
COPY apiCount.jar $CATALINA_HOME/
COPY eDM.jar $CATALINA_HOME/
COPY report.jar $CATALINA_HOME/
COPY uc.jar $CATALINA_HOME/
COPY upg.jar $CATALINA_HOME/

## copy venraas system files
COPY raas_db $CATALINA_HOME/
COPY install_bq.sh $CATALINA_HOME/
COPY itri_edm.backup $CATALINA_HOME/
COPY itri_unima.backup $CATALINA_HOME/
COPY itri_upg.backup $CATALINA_HOME/
COPY itri_schema.backup $CATALINA_HOME/
COPY service_account_key.json $CATALINA_HOME/
COPY dhermes_init_regs $CATALINA_HOME/dhermes_init_regs
## install gcloud sdk
RUN curl -sSL https://sdk.cloud.google.com | bash

ENV PATH $PATH:/root/google-cloud-sdk/bin  

EXPOSE 8080

ARG PROJECT_ID

# environment
ENV DEBIAN_FRONTEND noninteractive

### copy config to specific path
#COPY service_account_key.json /etc/td-agent/service_account_key.json
#COPY service_account_key.p12 /etc/td-agent/service_account_key.p12
#COPY td-agent.conf /etc/td-agent/td-agent.conf
#COPY filter_weblog.rb /etc/td-agent/plugin/

## install psql

RUN apt-get -y install postgresql

# Ubuntu packages
RUN apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*


### restart service 

CMD  /opt/tomcat/bin/catalina.sh run; 
#USER tomcat
RUN gcloud auth activate-service-account raas-system@venraas-test.iam.gserviceaccount.com --key-file=service_account_key.json
HEALTHCHECK --interval=10m --timeout=3s \
  CMD curl -f http://localhost:8080/raas/ || exit 1

