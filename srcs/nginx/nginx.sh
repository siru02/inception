#!/bin/sh

# 설정파일 이동
mv /default.conf /etc/nginx/http.d
mv /etc/nginx/fastcgi.conf /etc/nginx/http.d 

# mkdir -p /etc/nginx/ssl #왜 생성하나?

# openssl은 암호화 라이브러리로 SSl과 TLS(Transport Layer Security)구성에 사용
# openssl req명령으로 자체 서명된 인증서를 생성한다
# x509란 SSL/TLS에서 사용하는 인증서 형식인 X.509인증서를 생성하는데 사용하는 옵션
# 대칭키암호화방식으로는 TLS인증서를 발급 받을 수 없으므로 비대칭암호화 알고리즘인 rsa방식을 사용
# nodes옵션으로 비대칭키쌍을 생성할때 개인키를 암호화하지 않도록 설정한다
# keyout: 생성된 private키를 저장하는 경로, out: 생성된 인증서를 저장하는 경로, subj: 인증서의 주체에 대한 정보
openssl req -x509 -newkey rsa:2048 -nodes -days 365 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=KO/ST=Seoul/L=Gaepo/O=42Seoul/OU=hgu/CN=hgu.42.fr"

echo "nginx building success";

# nginx forgound에서 실행
nginx -g "daemon off;"
