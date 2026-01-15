# Setup

How to manage the project:
 * [Setup](./README.md#installation)
 * [Start](./README.md#starting)
 * [Stop](./README.md#stoping)
 * [Credentials](./srcs/.env)

# Build

You can do:
```bash
make setup build up
```

# Management

show container informations
```bash
cd srcs && docker compose ps
```

show volumes:
```bash
cd srcs && docker compose volumes ls
```
or you can look at `/home/nduvoid/data`

# Connection

Pour se connecter en ssh a la `VM` **Apres** avoir start la VM

```bash
ssh nduvoid@localhost -p 4241
```

# Watchtower
container under the watch of `watchtower` are
 - redis
 - adminer