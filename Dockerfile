FROM ubuntu-nginx-base:22.04

WORKDIR /app

COPY ./etcdkeeper /app/etcdkeeper
COPY ./nginx /app/nginx
COPY ./run.sh /app

EXPOSE 8080

RUN chmod +x ./*
# 编译安装nginx，使用nginx反向代理etcd以便etcdkeeper进行连接
RUN cd nginx && \
    ./configure && \
    make && \
    make install

ENV NGINX_HOME=/usr/local/nginx
ENV PATH=$NGINX_HOME/sbin:$PATH
ENV ETCD_URL=http://etcd:2379

ENTRYPOINT [ "./run.sh" ]

CMD [ "-p 8080" ]
