FROM ubuntu:22.04
LABEL maintainer="ImGunpoint"

# Prevent apt prompts from freezing the build
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV GOTTY_TAG_VER=v1.5.0

# 1. Install Core Dependencies, Python, and Proxychains4
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates wget git htop screen nano vim jq zip unzip \
    python3 python3-pip python3-venv build-essential \
    fzf ripgrep bat tree net-tools dnsutils gnupg proxychains4 \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Node.js v20 (LTS) & TypeScript (For Solana Bots)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g typescript ts-node yarn

# 3. Install GoLang (Required for the 'pforward' Go workspace)
RUN wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz && \
    rm go1.22.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# 4. Install GoTTY (The Web Terminal Engine)
RUN curl -sLk https://github.com/sorenisanerd/gotty/releases/download/${GOTTY_TAG_VER}/gotty_${GOTTY_TAG_VER}_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin

# 5. Styling: Neon Classglass V2 Colored Prompts & Aliases
RUN echo 'export PATH=$HOME/.local/bin:/usr/local/go/bin:$PATH' >> /root/.bashrc && \
    echo 'export PS1="\\[\\e[38;5;45m\\]⚡ ImGunpoint@Engine\\[\\e[m\\]:\\[\\e[38;5;82m\\]\\w\\[\\e[m\\]\\$ "' >> /root/.bashrc && \
    mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat || true

# 6. Set the Workspace
WORKDIR /workspace

# 7. Expose the GoTTY Web Port
EXPOSE 8080

# 8. The Bulletproof Boot Command (Replaces run_gotty.sh completely)
# This launches GoTTY directly into an indestructible screen session
CMD ["/usr/local/bin/gotty", "--permit-write", "--reconnect", "--title-format", "ImGunpoint Terminal", "/usr/bin/screen", "-xRR", "core_session"]
