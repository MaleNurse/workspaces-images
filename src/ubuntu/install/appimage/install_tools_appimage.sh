#!/usr/bin/env bash
#

apt-get update
apt-get upgrade -y
add-apt-repository -y universe
add-apt-repository -y ppa:appimagelauncher-team/stable
apt-get update
apt-get install -y libfuse2
apt-get install -y appimagelauncher
