#!/bin/bash

# 1. Start the system message bus (Strictly required by Cloudflare WARP)
mkdir -p /run/dbus
dbus-daemon --system

# 2. Start the Cloudflare WARP background daemon natively
warp-svc > /dev/null 2>&1 &

# Give the daemon 2 seconds to initialize its internal sockets
sleep 2

# 3. Start the GoTTY Web Terminal
/usr/local/bin/gotty --permit-write --reconnect --title-format "Dev Terminal" /usr/bin/screen -xRR gotty_session
