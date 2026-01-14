DIR_SRC			?= ./srcs
DIR_DATA		:= /home/nduvoid/data
MARIADB_DIR		:= $(DIR_DATA)/mariadb
WORDPRESS_DIR	:= $(DIR_DATA)/wordpress
ENV_FILE		:= $(DIR_SRC)/.env

-include $(ENV_FILE)
DOMAIN_NAME		?= nduvoid.42.fr

all: up

up:
	cd srcs && docker compose up

down:
	cd srcs && docker compose down

setup:
	mkdir -p $(MARIADB_DIR) $(WORDPRESS_DIR)
	@if ! grep -qF "$(DOMAIN_NAME)" /etc/hosts; then \
		echo "Adding $(DOMAIN_NAME) to /etc/hosts"; \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts >/dev/null; \
	else \
		echo "$(DOMAIN_NAME) already present in /etc/hosts"; \
	fi

build:
	export DOCKER_BUILDKIT=1 && \
	cd srcs && \
	docker compose build

clean:
	cd srcs && docker compose down -v

re: clean setup build
