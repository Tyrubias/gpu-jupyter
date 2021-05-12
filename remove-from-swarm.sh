#!/usr/bin/env bash
cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)" || exit

echo "Removing gpu-jupyter from docker swarm."
docker stack rm gpu
