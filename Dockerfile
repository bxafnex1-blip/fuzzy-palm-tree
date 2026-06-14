FROM debian:bullseye-slim
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.5.0

# Install Dev Enhancements, Node.js, and GoTTY in a highly optimized layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates wget git htop screen nano vim jq zip unzip \
    python3-minimal python3-pip python3-venv build-essential \
    fzf ripgrep bat tree net-tools dnsutils && \
    # Install Node.js v20
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    # Install GoTTY
    curl -sLk https://github.com/sorenisanerd/gotty/releases/download/${GOTTY_TAG_VER}/gotty_${GOTTY_TAG_VER}_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin && \
    # Setup 'bat' command alias (Debian installs it as 'batcat')
    mkdir -p ~/.local/bin && ln -s /usr/bin/batcat ~/.local/bin/bat && \
    # Aggressive cleanup to keep RAM/Disk usage low
    apt-get purge --auto-remove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add ~/.local/bin to PATH for 'bat', and create a color-coded bash prompt
RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> /root/.bashrc && \
    echo 'export PS1="\\[\\e[36m\\]\\u@gotty\\[\\e[m\\]:\\[\\e[32m\\]\\w\\[\\e[m\\]\\$ "' >> /root/.bashrc

COPY /run_gotty.sh /run_gotty.sh

RUN chmod 744 /run_gotty.sh

# Set a dedicated working directory for your bots
WORKDIR /workspace

EXPOSE 8080

CMD ["/bin/bash","/run_gotty.sh"]
