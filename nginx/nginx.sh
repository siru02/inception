#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/.initialized"

if [ ! -f "$INIT_FLAG" ]; then

    echo "Waiting db, wordpress"
    sleep 100

    #nginx -g daemon off


    touch $INIT_FLAG
fi

echo "building success";
