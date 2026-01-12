FROM debian:12

RUN apt update && apt install -y \
	nginx \
	openssl \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 80 443

ENTRYPOINT ["/setup.sh"]
