	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

	server {
			listen 80 default_server;
			listen [::]:80 default_server;
			return 301 https://$host$request_uri;
	}
	server {
			listen 443 ssl http2;
			listen [::]:443 ssl http2;

			root /var/www/html;
			autoindex on;
			index index.html index.php;

			ssl_certificate /etc/nginx/ssl/localhost.pem;
			ssl_certificate_key /etc/nginx/ssl/localhost.key;
			location / {
			try_files $uri $uri/ =404;
			}

			location ~ \.php$ {
					include snippets/fastcgi-php.conf;

					fastcgi_pass unix:/run/php/php7.3-fpm.sock;
			}

			location ~ /\.ht {
					deny all;
			}
	}
