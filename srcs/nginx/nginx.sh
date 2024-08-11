#!/bin/sh

# 초기화 여부 확인 

# wordpress, db컨테이너를 위해 대기
echo "Waiting db, wordpress"

if [ ! -f "$NGINX_INIT_FLAG" ]; then
    touch $NGINX_INIT_FLAG

    mv /etc/nginx/fastcgi.conf /etc/nginx/http.d 
    if [ ! -f /etc/ssl/private/nginx-selfsigned.key ]; then
    # keyout: 생성된 private키를 저장하는 경로, out: 생성된 인증서를 저장하는 경로, subj: 인증서의 주체에 대한 정보
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/ssl/private/nginx-selfsigned.key \
            -out /etc/ssl/certs/nginx-selfsigned.crt \
            -subj "/C=KO/ST=Seoul/L=Gaepo/O=42Seoul/OU=hgu/CN=hgu.42.fr"
    fi
fi

echo "nginx building success";

# nginx forgound에서 실행
nginx -g "daemon off;"
