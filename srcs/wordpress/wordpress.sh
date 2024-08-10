#!/bin/sh

# 초기화 여부 확인
# INIT_FLAG="/wordpress/.initialized"

# echo "sleeping"
# sleep 1

if [ ! -f "/wordpress/wp-config.php" ]; then

    # wp-cli 설치
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod 777 wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# wordpress설치
    mkdir -p /wordpress
    chmod -R 755 /wordpress
	wp core download --path=/wordpress # 루트디렉토리의 wordpress폴더에 설치한다
    cd /wordpress

    # 새로운 DB사용자 정보 설정 .env에 추가해야함
    WD_NAME="wordpress"
    WD_USER="hgu"
    WD_USER_PASS="1234"
    DB_HOST="mariadb"

    # wordpress conf파일 설정(db와 유저)
    # wp config create --dbhost=3306 --dbname=wordpress --dbuser=hgu --dbpass=1234
    wp config create --dbhost=mariadb --dbname=wordpress --dbuser=hgu --dbpass=1234

    # wordpress install
    wp core install --url=hgu_wordpress --title="hgu" --admin_user=hgu --admin_password=qwer --admin_email=khm32323@naver.coms
    
    # php-fpm
    adduser -S nginx && addgroup -S nginx
    sed -i 's/user = nobody/user = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/group = nobody/group = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.group = nginx/listen.group = nginx/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' /etc/php82/php-fpm.d/www.conf
    sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php82/php-fpm.d/www.conf       
    sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php82/php-fpm.conf
fi

echo "wordpress building success";

exec php-fpm82 -F

