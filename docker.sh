#!/bin/sh

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_STARTED_PLACEHOLDER"
if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED
	echo "-- First container startup - config in progress --"
    ./config.sh --url $GITHUB_URL --token $GITHUB_TOKEN
else
    echo "-- Not first container startup --"
fi

#always run
sudo dockerd & disown
./run.sh
