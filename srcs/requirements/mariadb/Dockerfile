FROM debian:Bookworm
WORKDIR /home/nduvoid

# TODO: RUN rule
RUN apt install mariadb

COPY . .
EXPOSE

CMD [ "sh" "./conf/setup.sh" ]