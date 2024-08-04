#!/bin/bash

base_image_name=ubuntu-nginx-base:22.04
etcdkeeper_image_name=etcdkeeper

docker rmi -f $base_image_name
docker rmi -f $etcdkeeper_image_name

docker build ./$base_image_name -t $base_image_name && \
    docker build . -t $etcdkeeper_image_name && \
    clear && \
    docker images | grep $etcdkeeper_image_name && \
    docker rmi -f $base_image_name