FROM debian:12

RUN apt-get update \
	&& apt-get install -y redis-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Disable protected mode so containers on the same network can connect
RUN sed -i 's/^protected-mode yes/protected-mode no/' /etc/redis/redis.conf

RUN echo "maxmemory 256mb" >> /etc/redis/redis.conf \
	&& echo "maxmemory-policy allkeys-lru" >> /etc/redis/redis.conf


EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
