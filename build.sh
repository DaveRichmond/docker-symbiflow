#!/bin/bash

. config.sh

docker build --no-cache -t ${CONTAINER}:$(date '+%Y%m%d') -t ${CONTAINER}:latest .
