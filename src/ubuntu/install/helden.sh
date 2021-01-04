#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install Helden-Software"
apt-get update
curl -SL https://keys.openpgp.org/vks/v1/by-fingerprint/F93BEB9A20BE5FD8C4C773CD9ECD827B5BE84F48 | apt-key add -
sh -c "echo 'deb http://online.helden-software.de/rep stable main' >> /etc/apt/sources.list"
apt-get update
apt-get install -y helden-software
apt-get clean -y
