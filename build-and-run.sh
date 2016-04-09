#!/bin/bash
if [ -z "$1" ]
  then
    echo "No password is given as argument"
    exit 1
fi

set -e

mkdir /home/db-volume
docker run --name curtain-db -e POSTGRES_PASSWORD=$1 -v /home/db-volume:/root/db-volume -d postgres

mkdir /home/app-volume
docker build --build-arg DATABASE_USER=postgres --build-arg DATABASE_PASSWORD=$1 --build-arg DATABASE_HOST=curtain-db --build-arg APP_URL=https://github.com/alicanerdogan/Curtain.git -t decauville:latest .
docker run -d --name curtain -v /home/app-volume:/root/app-volume -p 80:80 --link curtain-db decauville:latest