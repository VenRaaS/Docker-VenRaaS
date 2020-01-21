FROM postgres:9.3-alpine
MAINTAINER robinsu "robin.rsu@gmail.com"

## Change TimeZone
ENV TZ="Asia/Taipei"
RUN apk --update add tzdata    
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    date
RUN rm -rf /var/cache/apk/*

ENV POSTGRES_PASSWORD=w100@kuangfu501
ENV PGDATA=/media/postgres-data

RUN mkdir -p /media/postgres-data

