#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/.initialized"

# wordpress, db컨테이너를 위해 대기
echo "Waiting db, wordpress"
sleep 100

if [ ! -f "$INIT_FLAG" ]; then
    touch $INIT_FLAG
fi

if [ ! -f /etc/ssl/private/nginx-selfsigned.key ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt \
        -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=Cardet/CN=hgu.com"
    # openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    #     -keyout /etc/ssl/private/nginx-selfsigned.key \
    #     -out /etc/ssl/certs/nginx-selfsigned.crt \
    #     -subj "/C=KR/ST=Seoul/L=Seoul/O=MyCompany/OU=IT Department/CN=example.com"
fi

echo "building success";

# nginx forgound에서 실행
nginx -g "daemon off;"

