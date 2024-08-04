# docker-etcdkeeper

## docker build

完整目录结构：
```
.
└── etcdkeeper-docker
    ├── docker-build.sh
    ├── Dockerfile
    ├── etcdkeeper
    │   ├── assets
    │   ├── etcdkeeper
    │   ├── LICENSE
    │   └── README.md
    ├── nginx
    │   ├── auto
    │   ├── CHANGES
    │   ├── CHANGES.ru
    │   ├── conf
    │   ├── configure
    │   ├── contrib
    │   ├── html
    │   ├── LICENSE
    │   ├── man
    │   ├── README
    │   └── src
    ├── readme.md
    ├── run.sh
    └── ubuntu-nginx-base:22.04
        ├── docker-build.sh
        └── Dockerfile
```

1. 下载`etcdkeeper`，解压后放入`etcdkeeper`文件夹。
2. 下载`nginx`,解压后放入`nginx`文件夹。
3. 执行`sudo chmod +x docker-build.sh`
4. 执行`./docker-build.sh`

## docker run

```sh
# etcd 和 etcdkeeper 的网络
export NETWORK_NAME=etcd
# etcd 的容器名称，用于 etcdkeeper 连接 etcd
export ETCD_NAME=etcd
# 创建 etcd 网络
docker network create $NETWORK_NAME

# 创建 etcd 容器并加入 etcd 网络
docker run -d \
    -v etcd:/etc/ssl/certs \
    -p 4001:4001 \
    -p 2380:2380 \
    -p 2379:2379 \
    --network $NETWORK_NAME \
    --restart=always \
    --name $ETCD_NAME \
    quay.io/coreos/etcd:v2.3.8 \
    -name etcd0 \
    -advertise-client-urls http://${ETCD_NAME}:2379,http://${ETCD_NAME}:4001 \
    -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
    -initial-advertise-peer-urls http://${ETCD_NAME}:2380 \
    -listen-peer-urls http://0.0.0.0:2380 \
    -initial-cluster-token etcd-cluster-1 \
    -initial-cluster etcd0=http://${ETCD_NAME}:2380 \
    -initial-cluster-state new

# 创建 etcdkeeper 容器并加入 etcd 网络
docker run -d \
    -p 2381:8080 \
    -e ETCD_URL=http://$ETCD_NAME:2379 \
    --network $NETWORK_NAME \
    --restart=always \
    --name etcdkeeper \
    etcdkeeper
```
