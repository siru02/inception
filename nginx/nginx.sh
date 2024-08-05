#!/bin/sh

# 초기화 여부 확인
INIT_FLAG="/.initialized"

if [ ! -f "$INIT_FLAG" ]; then

    
    touch $INIT_FLAG
fi

echo "building success";
