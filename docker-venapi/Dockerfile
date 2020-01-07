FROM ubuntu:18.04

MAINTAINER robin.rsu@gmail.com

RUN apt-get update && \
    apt-get -y install sudo wget curl
## install openJDK
RUN apt-get update && \
    apt-get -y install openjdk-8-jdk
## install Python
RUN apt-get install -y python3-pip python3-dev \
    && cd /usr/local/bin \
    && ln -s /usr/bin/python3 python \
    && ln -s /usr/bin/pip3 pip \
    && pip3 install --upgrade pip

# environment
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install tzdata
ENV TZ="Asia/Taipei"
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
RUN curl -O http://apache.stu.edu.tw/tomcat/tomcat-8/v8.5.50/bin/apache-tomcat-8.5.50.tar.gz
RUN tar xvfz apache*.tar.gz
RUN mv apache-tomcat-8.5.50/* /opt/tomcat/.
RUN java -version

RUN mkdir /opt/tomcat/js
RUN mkdir /opt/tomcat/js/current/
WORKDIR /opt/tomcat/webapps
COPY venapis.war /opt/tomcat/webapps
COPY venraaspt.min.js /opt/tomcat/webapps/js/current/
COPY venraaspt.min.js /opt/tomcat/webapps/js

EXPOSE 8080

ARG PROJECT_ID
ENV DOMAIN_SUFFIX pri.venraas-test.tw
RUN awk -v alias=" ${DOMAIN_SUFFIX}" '/search/{print $0 alias; next}1' /etc/resolv.conf > /etc/resolv.tmp
#RUN cp -f /etc/resolv.tmp /etc/resolv.conf

# environment
ENV DEBIAN_FRONTEND noninteractive
## instal td-agent 
RUN apt -y install ruby-full
RUN apt-get install -y net-tools
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

### restart service 
CMD /etc/init.d/td-agent restart; \
    /opt/tomcat/bin/catalina.sh run; \
    python /opt/memstore-client/json2ms.py -ttl 2592000 -d /opt/tomcat/logs/data weblog tail;

