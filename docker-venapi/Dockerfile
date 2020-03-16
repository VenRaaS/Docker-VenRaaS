FROM ubuntu:18.04
LABEL INSTANCE_TYPE="venapis"
MAINTAINER robin.rsu@gmail.com

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
    mv apache-tomcat-8.5.50/* $CATALINA_HOME/.
RUN rm -rf $CATALINA_HOME/webapps/docs/; \
    rm -rf $CATALINA_HOME/webapps/examples/; \
    rm -rf $CATALINA_HOME/webapps/host-manager/; \
    rm -rf $CATALINA_HOME/webapps/manager/; \
    rm -rf $CATALINA_HOME/webapps/ROOT/;
## install venapis.war
COPY venapis.war $CATALINA_HOME/webapps
COPY venraaspt.min.js $CATALINA_HOME/webapps/js/current/
COPY venraaspt.min.js $CATALINA_HOME/webapps/js

EXPOSE 8080

ARG PROJECT_ID

# environment
ENV DEBIAN_FRONTEND noninteractive
## instal td-agent 
RUN apt -y install ruby-full && \
    apt-get install -y net-tools gnupg2 && \
    apt-get clean
RUN ruby --version
RUN curl -L https://toolbelt.treasuredata.com/sh/install-ubuntu-bionic-td-agent2.5.sh | sh 
RUN /usr/sbin/td-agent-gem install fluent-plugin-bigquery -v 0.4.4
RUN /usr/sbin/td-agent-gem install fluent-plugin-copy_ex -v 0.0.3 
RUN /usr/sbin/td-agent-gem install fluent-plugin-google-cloud-storage-out -v 0.1.12
### copy config to specific path
COPY service_account_key.json /etc/td-agent/service_account_key.json
COPY service_account_key.p12 /etc/td-agent/service_account_key.p12
COPY td-agent.conf /etc/td-agent/td-agent.conf
COPY filter_weblog.rb /etc/td-agent/plugin/

## install json2ms.py
RUN mkdir /opt/memstore-client
WORKDIR /opt/memstore-client
COPY memstore-client /opt/memstore-client
RUN pip install -r requirements.txt
RUN touch $CATALINA_HOME/logs/data

#RUN chown -R root:td-agent $CATALINA_HOME/logs
#RUN chmod -R 775 $CATALINA_HOME/logs/

# Ubuntu packages
RUN apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^TD_AGENT_USER=td-agent/TD_AGENT_USER=root/g' /etc/init.d/td-agent
### restart service 
CMD /etc/init.d/td-agent restart; \
    python /opt/memstore-client/json2ms.py -ttl 2592000 -d /opt/tomcat/logs/data weblog tail; \
    /opt/tomcat/bin/catalina.sh run; 

HEALTHCHECK --interval=10m --timeout=3s \
  CMD curl -f http://localhost:8080/venapis/alive || exit 1

