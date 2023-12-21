#!/usr/bin/env bash
#

apt-get update
apt-get upgrade -y
add-apt-repository universe
add-apt-repository ppa:appimagelauncher-team/stable
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
apt-get update
apt-get install -y libfuse2
apt-get install -y appimagelauncher
apt-get install -y git-lfs
