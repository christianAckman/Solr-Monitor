#!/bin/bash

declare -r COMPOSE_FILE_EXTRA="/vagrant/app/docker-compose-extra.yml"
declare -r COMPOSE_FILE="/vagrant/app/docker-compose.yml"
declare -r COMPOSE_WRAPPER="/vagrant/app/docker_compose"

function wait_and_run_indexer(){
    echo ${FUNCNAME[0]}

    local -r solr_ip=$(docker inspect --format='{{range .NetworkSettings.Networks}}~{{.IPAddress}}{{end}}' solr | cut -d'~' -f 3)
    local -r core="population"
    local -r solr_core_address="http://${solr_ip}:8983/solr/${core}/admin/ping"
    local attempt_counter=0
    local -r max_attempts=150

    # http://172.18.0.4:8983/solr/population/admin/ping
    # https://stackoverflow.com/questions/11904772/how-to-create-a-loop-in-bash-that-is-waiting-for-a-webserver-to-respond
    until $(curl --output /dev/null --silent --head --fail ${solr_core_address}); do
        if [ ${attempt_counter} -eq ${max_attempts} ];then
        echo "Max attempts reached -- could not reach solr core"
        exit 1
        fi

        echo 'Waiting for solr core.. attempt ' + "${attempt_counter}"
        attempt_counter=$(($attempt_counter+1))
        sleep 10
    done    

    echo "Running indexer.."
    ( cd /usr/local/bin/ || return
        docker-compose --file ${COMPOSE_FILE} up -d --no-deps --build indexer
    )
}

function main(){
    echo ${FUNCNAME[0]}
    install_docker
    install_docker_compose
    getDockerPermissions
    setup_compose_wrapper
    start_containers
    wait_and_run_indexer
}

function get_solr_permissions(){

    local -r SOLR_USER=8983
    local -r SOLR_CONFIG_DIR="/vagrant/app/solr/config"
    chown "${SOLR_USER}":"${SOLR_USER}" "${SOLR_CONFIG_DIR}"
    chmod 700 "${SOLR_CONFIG_DIR}"

    # groupadd -g "${SOLR_USER}"

    sudo chown -R 8983:8983 /vagrant/app/solr/config/population/data
    sudo chmod 700 /vagrant/app/solr/config/test
}


function start_containers(){
    echo ${FUNCNAME[0]}

    ( cd /usr/local/bin/ || return
        docker-compose --file ${COMPOSE_FILE} up -d  --no-deps --build solr #prometheus grafana angular-app
    )
}

function setup_compose_wrapper(){
    echo ${FUNCNAME[0]}
    sudo cp ${COMPOSE_WRAPPER} /usr/local/bin
    sudo chmod +x /usr/local/bin/docker-compose
}


function install_docker(){
    echo ${FUNCNAME[0]}

    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo apt-key fingerprint 0EBFCD88

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    sudo apt-get update

    sudo apt-get install -y docker-ce
}

function getDockerPermissions(){
    echo ${FUNCNAME[0]}
    sudo groupadd -f docker
    sudo usermod -aG docker vagrant
}

function install_docker_compose(){
    echo ${FUNCNAME[0]}
    curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    ( cd /usr/local/bin/ || return
        docker-compose --version
    )
}

main