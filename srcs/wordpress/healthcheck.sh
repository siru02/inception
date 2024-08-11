#!/bin/sh
set -e

CMD="SCRIPT_FILENAME=/app/index.php REQUEST_METHOD=GET cgi-fcgi -bind -connect localhost:9000"
RESPONSE=$(eval "$CMD" | tail -1)

if [ "$RESPONSE" = "UP" ]; then
  exit 0
else
  exit 1
fi
