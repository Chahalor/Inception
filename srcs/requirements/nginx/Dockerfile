FROM debian:12

RUN apt update && apt install -y \
	nginx \
	openssl \
	git \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/setup.sh /setup.sh
COPY site/ /var/www/html/site

RUN chmod +x /setup.sh

RUN git submodule update --recursive --remote

EXPOSE 80 443

ENTRYPOINT ["/setup.sh"]
