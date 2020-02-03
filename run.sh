#!/bin/bash

SCRIPTDIR=$(readlink -f $(dirname $0))

. ${SCRIPTDIR}/config.sh

docker run -it --rm -v $(pwd):/code ${CONTAINER}:latest $*
