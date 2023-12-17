#!/usr/bin/env bash
#

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
apt-get install -y jq
apt-get install -y g++
apt-get install -y ripgrep
apt-get install -y julia
apt-get install -y php
apt-get install -y composer
apt-get install -y ccls
apt-get install -y bat
apt-get install -y figlet
apt-get install -y luarocks
apt-get install -y lolcat
apt-get install -y libnotify-bin
apt-get install -y xclip
apt-get install -y xsel
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y python3-venv
apt-get install -y ruby
apt-get install -y ruby-dev
apt-get install -y wl-clipboard

install_fzf
install_lsd
