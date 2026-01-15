FROM debian:12

RUN apt-get update \
	&& apt-get install -y redis-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY redis.conf /etc/redis/redis.conf

# Disable protected mode and keep Redis in the foreground for Docker
# RUN sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf \
# 	&& sed -i 's/^daemonize .*/daemonize no/' /etc/redis/redis.conf \
# 	&& sed -i 's/^supervised .*/supervised no/' /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
