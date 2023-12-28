#!/usr/bin/env bash
#

apt-get update
apt-get upgrade -y
add-apt-repository -y universe
add-apt-repository -y ppa:appimagelauncher-team/stable
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
apt-get update
apt-get install -y libfuse2
apt-get install -y appimagelauncher
apt-get install -y git-lfs
