# Services

this project contain multiple differents stacks.
Such has `docker`, `mariadb`, `NGINX` and `wordpress`.
For the bonus container there is `adminer`

# Management

How to manage the project:
 * [Setup](./README.md#installation)
 * [Start](./README.md#starting)
 * [Stop](./README.md#stoping)
 * [Credentials](./srcs/.env)

To check the inception health, you can run
```bash
cd srcs && docker compose ps
```

# Access

 * [Wordpress](nduvoid.42.fr)
 * [wp admin](nduvoid.42.fr/wp-admin)
 * [Adminer](nduvoid.42.fr/adminer/)
 * FTP: use the `ftp` command on the host
 * [cAdvisor](http://localhost:8081/)

# Evaluation
 * check `nginx` port:
```bash
curl -k http://nduvoid.42.fr # or https://nduvoid.42.fr # for success
```
 * TLS certificate: 
```bash
docker exec -it nginx cat /etc/nginx/ssl/nduvoid.crt
```

 * checking db:
```bash
docker exec -it mariadb bash
mysql -u root -p
SHOW DATABASES;
```

* check `ftp`:
```
ftp localhost
<login>
<pwd>
put <file>
get <file>
...
```