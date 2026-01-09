all: up

up:
	docker compose up

setup:
	mkdir -p /home/nduvoid/data
	mkdir -p /home/nduvoid/data/mariadb
	mkdir -p /home/nduvoid/data/worldpress
	docekr compsoe up