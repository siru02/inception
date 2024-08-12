#!/bin/sh

# 초기화 여부 확인 TODO: 이렇게 하는게 맞는지 확인해야함 결국 재시작시 기록이 남아있나?
    
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mkdir -p /var/lib/mysql
    # chown -R mysql:mysql /var/lib/mysql
    chmod -R 755 /var/lib/mysql
fi

if [ ! -f "$DB_INIT_FLAG" ]; then
    # 초기화 완료 플래그 생성
    touch "$DB_INIT_FLAG"

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # MariaDB 백그라운드에서 실행 -> 테스트에서는 포그라운드에서 실행하도록
    /usr/bin/mysqld_safe --user=mysql --datadir=/var/lib/mysql &

    # MariaDB 서버가 시작될 때까지 대기
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    # MariaDB 접속 및 명령어 실행
    mysql -u $DB_USER -p$DB_PASS << EOF

    -- root계정 비밀번호 추가
    SET PASSWORD FOR root@localhost= PASSWORD("$DB_PASS");

    -- 빈유저 삭제
    USE mysql;
    DELETE FROM user WHERE User = '';

    -- 워드프레스 db생성 및 관리자 추가
    CREATE DATABASE IF NOT EXISTS $WD_NAME;
    CREATE USER IF NOT EXISTS '$WD_AD'@'%' IDENTIFIED BY '$WD_AD_PASS';
    GRANT ALL PRIVILEGES ON $WD_NAME.* TO '$WD_AD'@'%';
    FLUSH PRIVILEGES;

    -- 접속 종료
EOF

    # wordpress폴더 권한부여
    chmod -R 755 /var/lib/mysql/wordpress

    # MariaDB 종료
    mysqladmin -u root -pabcd shutdown

    echo "mariaDB setting flow complete";
fi

# MariaDB 설정파일 변경
config_file="/etc/my.cnf.d/mariadb-server.cnf"
sed -i 's/^skip-networking/#skip-networking/' $config_file # skip-networking을 주석처리하면 유닉스소켓대신 네트워크로 통신하겠다는 설정
sed -i 's/^#\s*bind-address/bind-address/' $config_file # bind-address는 maria-db에 연결허용할 ip주소를 설정한다

echo "mariadb building success";

# MariaDB 실행 (포그라운드)
exec /usr/bin/mysqld_safe --user=mysql --datadir=/var/lib/mysql
