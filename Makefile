all: up

up:
	cd srcs && docker compose up

setup:
	mkdir -p /home/nduvoid/data/mariadb
	mkdir -p /home/nduvoid/data/wordpress
	cd srcs && docker compose up