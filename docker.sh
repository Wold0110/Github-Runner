#!/bin/sh
sudo dockerd & disown
./config.sh --url $GITHUB_URL --token $GITHUB_TOKEN
./run.sh
#service docker start