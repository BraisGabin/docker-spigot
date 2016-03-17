#!/usr/bin/env bash

chown "$SPIGOT_USER:$SPIGOT_USER" $SPIGOT_HOME
echo "eula=${EULA:-false}" > $SPIGOT_HOME/eula.txt
chown "$SPIGOT_USER:$SPIGOT_USER" $SPIGOT_HOME/eula.txt

exec "$@"
