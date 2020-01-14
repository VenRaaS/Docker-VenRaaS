FROM ubuntu:18.04
LABEL INSTANCE_TYPE="recapi"
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
COPY cupid.war $CATALINA_HOME/webapps

EXPOSE 8080

ARG PROJECT_ID

# environment
ENV DEBIAN_FRONTEND noninteractive
## instal td-agent 
RUN apt -y install ruby-full
RUN apt-get install -y net-tools gnupg2
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

# Ubuntu packages
RUN apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*

### restart service 
CMD sed -i 's/^TD_AGENT_USER=td-agent/TD_AGENT_USER=root/g' /etc/init.d/td-agent && /etc/init.d/td-agent restart;  \
    /opt/tomcat/bin/catalina.sh run; 
