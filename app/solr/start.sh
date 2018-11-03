#!/bin/bash

declare -r SOLR_EXPORTER="/opt/solr/contrib/prometheus-exporter/bin/solr-exporter"
declare -r SOLR_EXPORTER_PORT=9983
declare -r SOLR="http://localhost:8983/solr"
declare -r SOLR_EXPORTER_CONFIG="/opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml"
declare -r SOLR_EXPORTER_THREADS=8


function start_solr_exporter(){
    echo ${FUNCNAME[0]}
    bash ${SOLR_EXPORTER} -p ${SOLR_EXPORTER_PORT} \
                          -b ${SOLR} \
                          -f ${SOLR_EXPORTER_CONFIG} \
                          -n ${SOLR_EXPORTER_THREADS} &
}

function main(){
    start_solr_exporter $@
}
main $@