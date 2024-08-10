#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/var/lib/mysql/.initialized"

# 데이터 베이스 접속 정보 설정
DB_PORT="3306"
DB_USER="root"
DB_PASS="abcd"
DB_NAME=""

# 새로운 DB사용자 정보 설정
WD_NAME="wordpress"
WD_USER="hgu"
WD_USER_PASS="1234"

if [ ! -f "$INIT_FLAG" ]; then
    # mysql 폴더 생성 및 권한 설정 TODO: makefile에서 수행해야한다
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mkdir -p /var/lib/mysql
        # chown -R mysql:mysql /var/lib/mysql
        chmod -R 755 /var/lib/mysql
    fi

	# MariaDB 데이터 디렉토리 초기화 / 이미 존재하면 실행되지 않으니 항상해도 됨
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # MariaDB 백그라운드에서 실행 -> 테스트에서는 포그라운드에서 실행하도록
    /usr/bin/mysqld_safe --user=mysql --datadir=/var/lib/mysql &

    # MariaDB 서버가 시작될 때까지 대기
    while ! mysqladmin ping --silent; do
        sleep 1
    done

    config_file="/etc/my.cnf.d/mariadb-server.cnf"

    # MariaDB 설정파일 변경
    sed -i 's/^skip-networking/#skip-networking/' $config_file # skip-networking을 주석처리하면 유닉스소켓대신 네트워크로 통신하겠다는 설정
    sed -i 's/^#\s*bind-address/bind-address/' $config_file # bind-address는 maria-db에 연결허용할 ip주소를 설정한다

    # MariaDB 접속 및 명령어 실행
    mysql -u $DB_USER -p$DB_PASS << EOF

    -- root계정 비밀번호 추가
    SET PASSWORD FOR root@localhost= PASSWORD("$DB_PASS");

    -- 빈유저 삭제
    USE mysql;
    DELETE FROM user WHERE User = '';

    -- 워드프레스 db생성 및 관리자 추가
    CREATE DATABASE IF NOT EXISTS $WD_NAME;
    CREATE USER IF NOT EXISTS '$WD_USER'@'%' IDENTIFIED BY '$WD_USER_PASS';
    GRANT ALL PRIVILEGES ON $WD_NAME.* TO '$WD_USER'@'%';
    FLUSH PRIVILEGES;

    -- 접속 종료
EOF

    # 초기화 완료 플래그 생성
    touch "$INIT_FLAG"

    # MariaDB 종료
    mysqladmin -u root -pabcd shutdown
fi

echo "building success";

# MariaDB 실행 (포그라운드)
exec /usr/bin/mysqld_safe --user=mysql --datadir=/var/lib/mysql
