FROM solr:7.5

COPY start.sh /docker-entrypoint-initdb.d/start.sh

# RUN chown -R "solr":"solr" /opt/solr/server/solr/mycores/
# RUN chown solr:solr /opt/solr/server/solr/mycores

# USER root
# RUN groupadd 1000
# RUN usermod -aG 1000 solr 
# USER solr

ENTRYPOINT [ "bash", "-c", "precreate-core population; solr-foreground" ]
# ENTRYPOINT [ "bash", "-c", "solr-foreground" ]