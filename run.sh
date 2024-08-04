#!/bin/bash
nginx_conf_file=$NGINX_HOME/conf/nginx.conf
nginx_conf_file_back=$nginx_conf_file.back

if [ ! -f $nginx_conf_file_back ]; then
    cp $nginx_conf_file $nginx_conf_file_back
fi

envsubst < $nginx_conf_file_back > $nginx_conf_file
# 启动 nginx 反向代理 etcd 到 localhost 以便 etcdkeeper 进行访问
nginx
# 启动 etcdkeeper
./etcdkeeper/etcdkeeper $1
