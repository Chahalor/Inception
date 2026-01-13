all: up

up:
	cd srcs && docker compose up

setup:
	mkdir -p /home/nduvoid/data/mariadb
	mkdir -p /home/nduvoid/data/wordpress
	cd srcs && docker compose up

build:
	export DOCKER_BUILDKIT=1 && \
	cd srcs && \
	docker compose build
