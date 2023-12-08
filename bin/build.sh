#!/usr/bin/env bash

if [ $# -ne 1 ]
  then
    echo "Usage:"
    echo "build.sh <tag>"
    exit 1
fi

docker build -t "fargot132/nginx-proxy-headers:$1" .
if [ $? -eq 0 ]; then
  echo "Debian build successful"
  docker push "fargot132/nginx-proxy-headers:$1"
fi

docker build -t "fargot132/nginx-proxy-headers:$1-alpine" -f Dockerfile.alpine .
if [ $? -eq 0 ]; then
  echo "Alpine build successful"
  docker push "fargot132/nginx-proxy-headers:$1-alpine"
fi

