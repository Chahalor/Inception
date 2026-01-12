# FROM debian:12
# RUN apt update && apt install -y mariadb-server mariadb-client

# COPY conf/start.sh /start.sh
# COPY conf/setup.sh /setup.sh

# RUN chmod +x /start.sh
# RUN chmod +x /setup.sh

# ENTRYPOINT [ "/setup.sh" ]


FROM debian:12

RUN apt-get update && apt-get install -y \
	mariadb-server \
	&& rm -rf /var/lib/apt/lists/*

# Empêche MariaDB de démarrer automatiquement
RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
