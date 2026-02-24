FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------
# System Update + Base Packages
# -----------------------------
RUN echo "=== Updating system packages ===" && \
    apt-get update && \
    apt-get install -y \
        curl \
        wget \
        git \
        ca-certificates \
        gnupg \
        lsb-release \
        build-essential \
        software-properties-common \
        nano && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------
# Install Docker CLI
# -----------------------------
RUN echo "=== Installing Docker CLI ===" && \
    apt-get update && \
    apt-get install -y docker.io && \
    docker --version && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------
# Install Node.js + npm (via NodeSource)
# -----------------------------
RUN echo "=== Installing Node.js and npm ===" && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    node -v && \
    npm -v && \
    rm -rf /var/lib/apt/lists/*

# -----------------------------
# Install NVM
# -----------------------------
ENV NVM_DIR=/root/.nvm

RUN echo "=== Installing NVM ===" && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
    . "$NVM_DIR/nvm.sh" && \
    nvm --version

# Make NVM available in future shells
ENV NODE_VERSION=22
RUN echo "=== Installing Node via NVM ===" && \
    . "$NVM_DIR/nvm.sh" && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION

ENV PATH="$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH"

# -----------------------------
# Install Go 1.23.10
# -----------------------------
ENV GO_VERSION=1.23.10

RUN echo "=== Installing Go ${GO_VERSION} ===" && \
    wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz && \
    /usr/local/go/bin/go version

ENV PATH="/usr/local/go/bin:${PATH}"

# -----------------------------
# Final check summary
# -----------------------------
RUN echo "=== Installation Summary ===" && \
    docker --version && \
    node -v && \
    npm -v && \
    nano --version && \
    go version

WORKDIR /workspace

CMD ["bash"]
