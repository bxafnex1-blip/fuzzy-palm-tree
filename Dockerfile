FROM debian:bookworm-slim
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.5.0

# Clean install of Dev Tools, Node v20, and GoTTY (No VPN tools)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl ca-certificates wget git htop screen nano vim jq zip unzip \
    python3-minimal python3-pip python3-venv build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    curl -sLk https://github.com/sorenisanerd/gotty/releases/download/${GOTTY_TAG_VER}/gotty_${GOTTY_TAG_VER}_linux_amd64.tar.gz \
    | tar xzC /usr/local/bin && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Color-coded prompt
RUN echo 'export PS1="\\[\\e[36m\\]\\u@gotty\\[\\e[m\\]:\\[\\e[32m\\]\\w\\[\\e[m\\]\\$ "' >> /root/.bashrc

COPY /run_gotty.sh /run_gotty.sh
RUN chmod 744 /run_gotty.sh

WORKDIR /workspace
EXPOSE 8080

CMD ["/bin/bash","/run_gotty.sh"]
