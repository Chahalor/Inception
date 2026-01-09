FROM debian:12
RUN apt update && apt install -y \
								php-fpm \
								php-mysql \
								php-json \
								php-curl \
								php-xml \
								php-mbstring \
								php-zip \
								curl \
								mariadb-client \
								&& rm -rf /var/lib/apt/lists/*

COPY conf/setup.sh /setup.sh
COPY conf/wp-config.php /wp-config.php

RUN chmod +x /setup.sh

WORKDIR /var/www/html

ENTRYPOINT [ "/setup.sh" ]