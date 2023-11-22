#!/usr/bin/env bash
set -xe
echo "Install Spiderfoot"

apt-get update
apt-get install -y python3-pip

# SPIDERFOOT_HOME=$HOME/spiderfoot
# mkdir -p $SPIDERFOOT_HOME
# cd $SPIDERFOOT_HOME
# wget https://github.com/smicallef/spiderfoot/archive/v4.0.tar.gz
# tar zxvf v4.0.tar.gz
cd $HOME
git clone https://github.com/smicallef/spiderfoot.git
cd spiderfoot
pip3 install -r requirements.txt

find $HOME/spiderfoot -type d | xargs chmod 755
chown -R 1000:1000 $HOME/spiderfoot
