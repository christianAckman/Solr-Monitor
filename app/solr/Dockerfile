FROM solr:7.5

COPY start.sh /docker-entrypoint-initdb.d/start.sh

ENTRYPOINT [ "bash", "-c", "precreate-core population; solr-foreground" ]