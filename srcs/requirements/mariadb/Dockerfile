FROM debian:bullseye
RUN apt update && apt install mariadb-server mariadb-client

COPY conf/start.sh /start.sh
COPY conf/setup.sh /setup.sh

RUN chmod -x /start.sh
RUN chmod -x /setup.sh

CMD [ "/setup.sh" ]