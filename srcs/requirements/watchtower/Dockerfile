FROM alpine:3.19

RUN apk add --no-cache docker-cli bash curl jq

COPY conf/watch.sh /watch.sh
RUN chmod +x /watch.sh

ENTRYPOINT ["/watch.sh"]
