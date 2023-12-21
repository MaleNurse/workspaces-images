#!/usr/bin/env bash
set -xe
echo "Install Maltego and Spiderfoot"

apt-get update
apt-get upgrade -y
apt-get install -y default-jre
apt-get install -y file

MALTEGO_URL=$(curl -sq https://downloads.maltego.com/maltego-v4/info.json | grep -e "url.*deb"  | cut -d '"' -f4 | head -1)

wget -q $MALTEGO_URL -O maltego.deb
apt-get install -y ./maltego.deb
rm maltego.deb

chown 1000:1000 /usr/share/applications/maltego.desktop
cp /usr/share/applications/maltego.desktop $HOME/Desktop/
chmod 755 $HOME/Desktop/maltego.desktop

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
