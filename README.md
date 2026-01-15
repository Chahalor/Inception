this project has been created as part of the **42 curriculum** by [nduvoid](https://profile.intra.42.fr/users/nduvoid)

# Description

This project goal is to introduce us to the wonderfull world of docker. More precisly `docker compose`
We has be given the task to create 3 service all connected to each other and make them work.
 * A container with `mariadb` for wordpress static data
 * A container with `nginx` for the server security
 * A container with `wordpress` for the website
 * A container with `adminer` running on it
 * A container with `FPT` running in the localhost
 * A container with `redis cache` for the wordpress page caching

# Instructions

## Installation
```bash
sudo apt update && apt install make
sudo apt install docker
```

## starting
```bash
make setup	# will setup de VM to be prefect
make build	# will build all docker images
make up		# will launch the project
```

## Stoping
```bash
make down	# shut down the docker compose
make clean	# will clean the images
```
# Ressources

## Documentation
 * [Docker](https://docs.docker.com/)
 * [Mariadb](https://mariadb.com/kb/en/documentation)
 * [NGINX](https://nginx.org/en/docs/)
 * [Wordpress](https://wordpress.org/documentation/)
 * [adminer](https://www.adminer.org/en/)
 * [FTP](https://www.rfc-editor.org/rfc/rfc959)
 * [redis cache](https://redis.io/docs/latest/)
* [watchtower](https://containrrr.dev/watchtower/)

## AI
Mostly to get documentation or to have exemple for like dockerfile or config file

# Docker vs Virtual Machine

| Theme								| Docker																															| Virtual Machine |
|:---------------------------------:|:---------------------------------------------------------------------------------------------------------------------------------:|:---------------:|
| Virtualization Model				| OS-level virtualization. Containers share the host OS kernel. Lightweight and fast.												| Hardware-level virtualization. Each VM runs its own full OS. Heavy but isolated. |
| Secrets vs Environment Variables	| Secrets are usually managed via Docker Secrets, Kubernetes Secrets, or external vaults. Env vars are easy but insecure if leaked.	| Secrets often stored in OS-level secret managers or config files. Env vars exist but are less central to the model. |
| Docker Network vs Host Network	| Uses virtual networks (bridge, overlay). Containers communicate via internal DNS. Host network mode exists but reduces isolation.	| Uses virtual NICs bridged or NATed to the host. Networking is closer to physical machines. |
| Docker Volumes vs Bind Mounts		| Volumes are managed by Docker, portable, safer, and preferred for persistent data.												| Storage is typically virtual disks attached to the VM. Managed at the hypervisor or OS level. |


# Features
Each service has a focused job and communicates over the private `inception`
network.

## mariadb
- Persistent database for WordPress; data is stored in `mariadb_data`.
- First boot initializes users and the database from `.env` (`MYSQL_*` vars).
- Exposes 3306 inside the compose network and includes a healthcheck.

## nginx
- Terminates TLS and serves the WordPress files over HTTPS (host port 443).
- Self-signed cert is generated at container start for `nduvoid.42.fr`.
- Proxies PHP requests to `wordpress:9000` and `/adminer/` to `adminer:8080`.

## wordpress
- PHP-FPM 8.2 container that installs WordPress on first run via WP-CLI.
- Creates admin/user accounts from `.env` (`WP_*` vars) and enables Redis cache.
- Content lives in `wordpress_data` so files persist across restarts.

## adminer
- Lightweight DB UI served on 8080 inside the network.
- Exposed to the host through nginx at `https://<host>/adminer/`.

## FTP
- `vsftpd` server for uploading/downloading site files.
- Uses the WordPress volume as the FTP root and exposes ports 21 + 21000-21010.
- User is created at build time from `FTP_USER` (password defaults to the same).

## Redis
- In-memory cache used by WordPress (Redis Object Cache plugin).
- Configured with `maxmemory 256mb` and `allkeys-lru` eviction policy.

## Watchtower
- Minimal update loop that checks every 5 minutes for image updates.
- Only updates containers labeled `watchtower.enable=true`.
- Requires the Docker socket to inspect/pull/recreate containers.
## Redis
## Watchtower