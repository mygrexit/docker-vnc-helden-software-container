#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install JRE 8"
apt-get update 
apt-get install -y openjdk-8-jre
apt-get clean -y
