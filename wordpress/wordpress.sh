#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/var/lib/wordpress/.initialized"

if [ ! -f "$INIT_FLAG" ]; then
    # worpress 폴더 생성 및 권한 설정 # TODO: 이 부분은 makefile에서 수행해야한다
    if [ ! -d "/var/lib/wordpress" ]; then
        mkdir -p /var/lib/worpress
        chmod -R 755 /var/lib/wodpress
    fi

    # wp-cli 설치
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod 777 wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# wordpress설치
	mkdir /var/www
	mkdir /var/www/html
	wp core download --path=/var/www/html

    # 새로운 DB사용자 정보 설정
    WD_NAME="wordpress"
    WD_USER="hgu"
    WD_USER_PASS="1234"
    #DB_HOST="mariadb"
    # wordpress conf파일 설정(db와 유저)
    wp config create --dbhost=$DB_HOST --dbname=$WD_NAME --dbuser=$WD_USER --dbpass=$WD_USER_PASS

    # wordpress install
    wp core install --url=hgu_wordpress --title="hgu" --admin_user=hgu --admin_password=qwer --admin_email=khm32323@naver.coms




fi

echo "building success";
