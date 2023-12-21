#!/usr/bin/env bash
#

apt-get update
apt-get upgrade -y
add-apt-repository universe
add-apt-repository ppa:appimagelauncher-team/stable
apt-get update
apt-get install -y libfuse2
apt-get install -y appimagelauncher
