FROM debian:12

RUN apt-get update && apt-get install -y \
	nginx \
	ca-certificates \
	git \
	&& rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/sites-enabled/default

RUN chown -R www-data:www-data /var/www/html

RUN git clone https://github.com/Chahalor/Chahalor.github.io.git /var/www/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]