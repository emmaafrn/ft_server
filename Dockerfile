FROM debian:buster

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install bash wget openssl nginx
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring php-xmlrpc php-xml
RUN apt-get -y install mariadb-server
ADD ./srcs ./srcs
EXPOSE 80 443
WORKDIR /var/www/html
RUN wget https://fr.wordpress.org/latest-fr_FR.tar.gz
RUN tar -xvf latest-fr_FR.tar.gz
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.gz
RUN tar -xvf phpMyAdmin-5.1.0-all-languages.tar.gz
RUN mv phpMyAdmin-5.1.0-all-languages phpmyadmin
RUN cp /srcs/wp-config.php /var/www/html/wordpress
RUN cp /srcs/config.inc.php /var/www/html/phpmyadmin
WORKDIR /
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
RUN cp /srcs/config /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/config /etc/nginx/sites-enabled
RUN service mysql start && mysqladmin -u root password root && mysql -u root -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES; update mysql.user set plugin='' where user='root';"
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -nodes -out /etc/nginx/ssl/localhost.pem -keyout /etc/nginx/ssl/localhost.key -subj "/C=FR/ST=Lyon/L=Lyon/O=42 School/OU=emma/CN=localhost"
ENTRYPOINT service php7.3-fpm start && service mysql start && service nginx start && /bin/bash