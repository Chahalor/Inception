all: up

up:
	cd srcs && docker compose up

setup:
	cd srcs && docker compose up