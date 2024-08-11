#!/bin/sh

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

    # wordpress conf파일 설정(db와 유저)
    wp config create --dbhost=$DB_HOST --dbname=$WD_NAME --dbuser=$WD_AD --dbpass=$WD_AD_PASS

    # wordpress install
    wp core install --url=42.hgu.fr --title=hgu --admin_user=$WD_AD --admin_password=$WD_AD_PASS --admin_email=khm32323@naver.coms
    
    # create user
    wp user create $WD_USER $WD_USER_EMAIL --role=author --user_pass=$WD_USER_PASS

    # php-fpm
    adduser -S nginx && addgroup -S nginx
    mv /www.conf /etc/php82/php-fpm.d/
    mv /php-fpm.conf /etc/php82/
    # sed -i 's/user = nobody/user = nginx/g' /etc/php82/php-fpm.d/www.conf
    # sed -i 's/group = nobody/group = nginx/g' /etc/php82/php-fpm.d/www.conf
    # sed -i 's/;listen.owner = nobody/listen.owner = nginx/g' /etc/php82/php-fpm.d/www.conf
    # sed -i 's/;listen.group = nginx/listen.group = nginx/g' /etc/php82/php-fpm.d/www.conf
    # sed -i 's/listen.mode = 0660/listen.mode = 0660/g' /etc/php82/php-fpm.d/www.conf
    # sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php82/php-fpm.d/www.conf       
    # sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php82/php-fpm.conf
fi

echo "wordpress building success";

exec php-fpm82 -F

