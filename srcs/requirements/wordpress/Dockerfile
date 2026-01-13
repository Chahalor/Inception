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
# RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf \
#  && sed -i 's|^;*listen.allowed_clients =.*|listen.allowed_clients = 0.0.0.0|' \
#     /etc/php/8.2/fpm/pool.d/www.conf


WORKDIR /var/www/html

ENTRYPOINT [ "/setup.sh" ]