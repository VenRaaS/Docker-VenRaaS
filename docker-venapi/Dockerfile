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

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

## install json2ms.py
RUN mkdir /opt/memstore-client
WORKDIR /opt/memstore-client
COPY memstore-client /opt/memstore-client
RUN pip install -r requirements.txt

