FROM docker.elastic.co/elasticsearch/elasticsearch:6.8.6
LABEL INSTANCE_TYPE="es-nodes"
MAINTAINER robin.rsu@gmail.com

COPY --chown=elasticsearch:root template_hermes.json /usr/share/elasticsearch/_template/
COPY --chown=elasticsearch:root template_venraas.json /usr/share/elasticsearch/_template/
COPY --chown=elasticsearch:root template_cap.json /usr/share/elasticsearch/_template/
COPY --chown=elasticsearch:root template_gocc.json /usr/share/elasticsearch/_template/


