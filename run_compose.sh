#!/bin/bash
# Author: Mecu Sorin       Phone: 0040747020102 
# Dev time deleting and recreating a docker-compose container

date2stamp () {
    date --utc --date "$1" +%s
}

stamp2date (){
    date --utc --date "1970-01-01 $1 sec" "+%Y-%m-%d %T"
}

dateDiff (){
    case $1 in
        -s)   sec=1;      shift;;
        -m)   sec=60;     shift;;
        -h)   sec=3600;   shift;;
        -d)   sec=86400;  shift;;
        *)    sec=86400;;
    esac
    dte1=$(date2stamp $1)
    dte2=$(date2stamp $2)
    diffSec=$((dte2-dte1))
    if ((diffSec < 0)); then abs=-1; else abs=1; fi
    echo $((diffSec/sec*abs))
}


diff=$(dateDiff  "2016-08-12" "now")
name=$(uname -n)

if [ "$name" == "Tarr" ] && [ "$diff" -eq "0" ]
then
    docker rm $(docker ps -qaf "since=tensorflow-udacity")
    docker rmi $(docker images -qf "since=composetest_web")
    docker build -t todel --rm .
    docker build -t loadbalancer-nginx --rm nginx/
    docker-compose up
else
    echo "Take care you can delete docker images and containers"
fi