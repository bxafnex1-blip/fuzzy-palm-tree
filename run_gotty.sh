#!/bin/bash

# ENHANCEMENTS:
# --permit-write : Allows you to type in the browser.
# --reconnect    : Automatically attempts to reconnect if your internet drops.
# --title-format : Changes the browser tab name.
# screen -xRR    : Attaches to an existing screen session, or creates one if it doesn't exist.

/usr/local/bin/gotty --permit-write --reconnect --title-format "Dev Terminal" /usr/bin/screen -xRR gotty_session
