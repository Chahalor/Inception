# =========================
# Stage 1: build
# =========================
FROM debian:bookworm AS builder

RUN apt-get update && apt-get install -y \
	golang \
	git \
	ca-certificates \
	gcc \
	libc6-dev \
	libseccomp-dev \
	libudev-dev \
	pkg-config \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /build
RUN mkdir ./cmd/cadvisor

RUN git clone https://github.com/google/cadvisor.git .
RUN git checkout v0.49.1

ENV CGO_ENABLED=1
ENV GO111MODULE=on

# IMPORTANT: build with tags expected by cadvisor
RUN go build \
	-tags "netgo osusergo" \
	-o cadvisor \
	./cmd/cadvisor
# =========================
# Stage 2: runtime
# =========================
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
	ca-certificates \
&& rm -rf /var/lib/apt/lists/*

COPY --from=builder /build/cadvisor /usr/bin/cadvisor

EXPOSE 8080

ENTRYPOINT ["/usr/bin/cadvisor"]
