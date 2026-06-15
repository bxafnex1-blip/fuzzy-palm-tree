#!/bin/bash

# Launches GoTTY and attaches to a persistent screen session.
# If you close the browser, your bot keeps running!
/usr/local/bin/gotty --permit-write --reconnect --title-format "Dev Terminal" /usr/bin/screen -xRR gotty_session
