#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/var/lib/wordpress/.initialized"

# 새로운 DB사용자 정보 설정
WD_NAME="wordpress"
WD_USER="hgu"
WD_USER_PASS="1234"

if [ ! -f "$INIT_FLAG" ]; then
    # mysql 폴더 생성 및 권한 설정
    if [ ! -d "/var/lib/mariaDB/mysql" ]; then
        mkdir -p /var/lib/mariaDB
        chown -R mysql:mysql /var/lib/mariaDB
        chmod -R 755 /var/lib/mariaDB
    fi

    # MariaDB 서버가 시작될 때까지 대기
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    config_file="/etc/my.cnf.d/mariadb-server.cnf"
fi

echo "building success";
