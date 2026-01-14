FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php \
	php-mysql \
	php-mysqli \
	wget \
	ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN wget https://www.adminer.org/latest.php -O adminer.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
