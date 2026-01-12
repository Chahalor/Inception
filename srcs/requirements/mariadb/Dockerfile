FROM debian:12

RUN apt-get update && apt-get install -y \
	mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' \
	/etc/mysql/mariadb.conf.d/50-server.cnf

COPY conf/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
