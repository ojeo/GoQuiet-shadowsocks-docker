FROM shadowsocks/shadowsocks-libev:latest
USER root
ARG GOQUIET_VER=1.2.2

ENV SS_SERVER_HOST=0.0.0.0
ENV SS_SERVER_PORT=8188
ENV DNS_ADDRS=8.8.8.8,8.8.4.4
ENV GQ_SERVER_HOST=0.0.0.0
ENV GQ_SERVER_PORT=443
ENV GQ_LOCAL_HOST=0.0.0.0
ENV GQ_LOCAL_PORT=8288
ENV SS_LOCAL_ADDRESS=0.0.0.0
ENV SS_LOCAL_PORT=8388
ENV SS_METHOD=aes-256-cfb
ENV SS_TIMEOUT=300
ENV GQ_FAST_OPEN=false
ENV GQ_SERVER_NAME=www.baidu.com
ENV GQ_WEBSERVER_ADDRESS=104.193.88.123:443
ENV GQ_TICKET_TIME_HINT=3600
ENV GQ_BROWSER=chrome
ENV OPT_TYPE=SS_SERVER_WITH_GOQUIET

COPY gq-client-linux-386-1.2.2 /usr/local/bin/gq-client
COPY gq-server-linux-386-1.2.2 /usr/local/bin/gq-server
RUN chmod +x /usr/local/bin/gq-client \
    & chmod +x /usr/local/bin/gq-server
RUN \
    mkdir -p /etc/goquiet/ 
COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

