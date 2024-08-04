#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/var/lib/wordpress/.initialized"

if [ ! -f "$INIT_FLAG" ]; then

    # wp-cli 설치
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod 777 wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# wordpress설치
	mkdir /var/www
	mkdir /var/www/html
	wp core download --path=/var/www/html
    echo "here1"

    # 새로운 DB사용자 정보 설정
    WD_NAME="wordpress"
    WD_USER="hgu"
    WD_USER_PASS="1234"
    #DB_HOST="mariadb"
    DB_HOST="172.17.0.2"

    # wordpress conf파일 설정(db와 유저)
    cd /var/www/html
    wp config create --dbhost=$DB_HOST --dbname=$WD_NAME --dbuser=$WD_USER --dbpass=$WD_USER_PASS
    echo "here2"

    # wordpress install
    wp core install --url=hgu_wordpress --title="hgu" --admin_user=hgu --admin_password=qwer --admin_email=khm32323@naver.coms
    
    sed -i 's/user = nobody/user = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/group = nobody/group = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.group = nginx/listen.group = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php82/php-fpm.d/www.conf       
    
    sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php8/php-fpm.conf

    exec php-fpm
fi

echo "building success";
