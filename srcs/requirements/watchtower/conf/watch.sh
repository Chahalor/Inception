#!/bin/bash

INTERVAL=300

while true; do
	echo "[watchtower-lite] checking for updates..."

	for c in $(docker ps --format '{{.Names}}'); do
		ENABLED=$(docker inspect \
			--format='{{ index .Config.Labels "watchtower.enable" }}' \
			"$c")

		if [ "$ENABLED" != "true" ]; then
			continue
		fi

		IMAGE=$(docker inspect --format='{{.Config.Image}}' "$c")

		echo "[watchtower-lite] checking $c ($IMAGE)"

		docker pull "$IMAGE" >/dev/null || continue

		docker stop "$c"
		docker rm "$c"
		docker run -d \
			$(docker inspect "$c" | jq -r '.[0].HostConfig.Binds[] | "-v " + .') \
			--name "$c" \
			"$IMAGE"
	done

	sleep "$INTERVAL"
done
