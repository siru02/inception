#!/bin/sh

if [ ! -f "/wordpress/wp-config.php" ]; then

    # wp-cli 설치
	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod 777 wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
		
	# wordpress설치
    mkdir -p /wordpress
    chmod -R 755 /wordpress
	wp core download --path=/wordpress # 루트디렉토리의 wordpress폴더에 wordpress파일다운
    cd /wordpress

    # wordpress conf파일 설정(db와 유저)
    wp config create --dbhost=$DB_HOST --dbname=$WD_NAME --dbuser=$WD_AD --dbpass=$WD_AD_PASS

    # wordpress install
    wp core install --url=$DOMAIN_NAME --title=hgu --admin_user=$WD_AD --admin_password=$WD_AD_PASS --admin_email=$WD_AD_EMAIL
    
    # create user
    wp user create $WD_USER $WD_USER_EMAIL --role=author --user_pass=$WD_USER_PASS

    mkdir /wordpress/a
    cd /wordpress/a
    cat "index1" > index1.html
    cat "index2" > index2.html
    mkdir b
    echo "wordpress install flow complete";

fi

adduser -S nginx && addgroup -S nginx
mv /www.conf /etc/php82/php-fpm.d/
mv /php-fpm.conf /etc/php82/

chown -R nginx:nginx /wordpress

echo "wordpress building success";

exec php-fpm82 -F

