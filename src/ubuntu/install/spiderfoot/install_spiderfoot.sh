#!/usr/bin/env bash
set -xe
echo "Install Spiderfoot"

apt-get update
apt-get install -y python3-pip

cd $HOME
git clone https://github.com/smicallef/spiderfoot.git
cd spiderfoot
pip3 install -r requirements.txt

find $HOME/spiderfoot -type d | xargs chmod 755
chown -R 1000:1000 $HOME/spiderfoot
