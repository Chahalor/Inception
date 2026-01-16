FROM debian:12

ARG GIT

RUN apt update && apt install -y \
	nginx \
	openssl \
	git \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/setup.sh /setup.sh
RUN chmod +x /setup.sh

RUN mkdir -p /var/www/html

RUN test -n "$GIT"

EXPOSE 80 443
ENTRYPOINT ["/setup.sh"]
