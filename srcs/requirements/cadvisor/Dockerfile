# =========================
# Stage 1: build
# =========================
FROM debian:bookworm AS builder

RUN apt-get update && apt-get install -y \
    golang \
    git \
    make \
    ca-certificates \
    gcc \
    libc6-dev \
    libseccomp-dev \
    libudev-dev \
    pkg-config \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone https://github.com/google/cadvisor.git .

# cAdvisor NEEDS CGO
ENV CGO_ENABLED=1

RUN make build

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
