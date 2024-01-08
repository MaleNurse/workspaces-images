#!/usr/bin/env bash
#

apt-get update -y
apt-get upgrade -y
apt-get install -y fuse3

curl https://rclone.org/install.sh | bash
