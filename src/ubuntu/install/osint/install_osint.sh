#!/usr/bin/env bash
set -xe
echo "Install Maltego and Spiderfoot"

install_external_package() {
  API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "\.amd64\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling %s ..." "${PROJECT}"
    TEMP_DEB="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_DEB}" "${DL_URL}"
    chmod 644 "${TEMP_DEB}"
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    printf " done"
  }
}

install_fzf() {
  API_URL="https://api.github.com/repos/junegunn/fzf/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "linux_amd64\.tar\.gz")

  [ "${DL_URL}" ] && {
    TEMP_TGZ="$(mktemp --suffix=.tgz)"
    wget --quiet -O "${TEMP_TGZ}" "${DL_URL}"
    chmod 644 "${TEMP_TGZ}"
    mkdir -p /tmp/fzft$$
    tar -C /tmp/fzft$$ -xzf "${TEMP_TGZ}"
    [ -f /tmp/fzft$$/fzf ] && {
      cp /tmp/fzft$$/fzf ${HOME}/.local/bin/fzf
      chmod 755 ${HOME}/.local/bin/fzf
    }
    rm -f "${TEMP_TGZ}"
    rm -rf /tmp/fzft$$
  }
}

install_lsd() {
  API_URL="https://api.github.com/repos/lsd-rs/lsd/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "lsd_" | grep "_amd64\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling LSD ..."
    TEMP_DEB="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_DEB}" "${DL_URL}"
    chmod 644 "${TEMP_DEB}"
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    printf " done"
  }
}

export GH_TOKEN="__GITHUB_API_TOKEN__"
if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

apt-get update
apt-get install -y apt-utils
apt-get install -y default-jre
apt-get install -y build-essential
apt-get install -y curl
apt-get install -y file
apt-get install -y git
apt-get install -y git-core
apt-get install -y jq
apt-get install -y bat
apt-get install -y libnotify-bin
apt-get install -y xclip
apt-get install -y xsel
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y python3-venv
apt-get install -y exuberant-ctags
apt-get install -y dialog
apt-get install -y highlight
apt-get install -y neofetch
apt-get install -y catdoc
apt-get install -y pandoc
apt-get install -y ranger

MALTEGO_URL=$(curl -sq https://downloads.maltego.com/maltego-v4/info.json | grep -e "url.*deb"  | cut -d '"' -f4 | head -1)

wget -q $MALTEGO_URL -O maltego.deb
apt-get install -y ./maltego.deb
rm maltego.deb

chown 1000:1000 /usr/share/applications/maltego.desktop
cp /usr/share/applications/maltego.desktop $HOME/Desktop/
chmod 755 $HOME/Desktop/maltego.desktop

install_fzf
install_lsd

OWNER=doctorfree
PROJECT=btop
install_external_package

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
