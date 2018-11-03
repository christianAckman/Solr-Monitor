#!/bin/bash


function start(){
    echo ${FUNCNAME[0]}
    node indexer.js "${1}"
}

function main(){
    echo ${FUNCNAME[0]}
    local -r args="${1}"
    start "${args}"
}
main $@