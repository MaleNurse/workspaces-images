#!/usr/bin/env bash
#

OWNER=doctorfree

install_asciiville() {
  API_URL="https://api.github.com/repos/${OWNER}/Asciiville/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling Asciiville ..."
    TEMP_DEB="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_DEB}" "${DL_URL}"
    chmod 644 "${TEMP_DEB}"
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    printf " done"
  }
}

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

# GH_TOKEN, a GitHub token must be set in the environment
export GH_TOKEN="__GITHUB_API_TOKEN__"

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

apt-get update
apt-get install -y apt-utils
apt-get install -y curl
apt-get install -y jq
apt-get install -y fzf
apt-get install -y g++
apt-get install -y ripgrep
apt-get install -y bat
apt-get install -y figlet
apt-get install -y lolcat
apt-get install -y libnotify-bin
apt-get install -y xclip
apt-get install -y xsel
apt-get install -y python3
apt-get install -y python3-venv
apt-get install -y uuid-runtime
apt-get install -y libaa-bin
apt-get install -y libaa1
apt-get install -y bb
apt-get install -y dconf-cli
apt-get install -y libncurses-dev
apt-get install -y libjpeg-dev
apt-get install -y libpng-dev
apt-get install -y khard
apt-get install -y git
apt-get install -y mplayer
apt-get install -y libportaudio2
apt-get install -y libportaudiocpp0
apt-get install -y portaudio19-dev
apt-get install -y golang
apt-get install -y bsdgames
apt-get install -y greed
apt-get install -y nudoku
apt-get install -y dialog
apt-get install -y ruby
apt-get install -y ruby-dev
apt-get install -y exuberant-ctags
apt-get install -y highlight
apt-get install -y neofetch
apt-get install -y catdoc
apt-get install -y pandoc
apt-get install -y ranger
apt-get install -y tmux
apt-get install -y w3m
apt-get install -y asciinema
apt-get install -y gnupg
apt-get install -y zip
apt-get install -y imagemagick
apt-get install -y cmatrix
apt-get install -y neomutt
apt-get install -y newsboat
apt-get install -y speedtest-cli
apt-get install -y ca-certificates
apt-get install -y julia
apt-get install -y php
apt-get install -y composer
apt-get install -y ccls
apt-get install -y luarocks
apt-get install -y wl-clipboard
apt-get install -y ubuntu-desktop

install_lsd

install_asciiville

PROJECT=asciigames
install_external_package
PROJECT=btop
install_external_package
PROJECT=any2ascii
install_external_package
PROJECT=endoh1
install_external_package
PROJECT=asciiville-aewan
install_external_package
PROJECT=cbftp
install_external_package

FIGLET_DIR="/usr/share/figlet-fonts"
FIGLET_ZIP="figlet-fonts.zip"
zip_inst=$(type -p zip)
if [ "${zip_inst}" ]; then
  pyfig_inst=$(type -p pyfiglet)
  [ "${pyfig_inst}" ] || {
    python3 -m pip install pyfiglet
    pyfig_inst=$(type -p pyfiglet)
  }
  if [ "${pyfig_inst}" ]; then
    PYFIG=$(command -v pyfiglet)
    ZIP=$(command -v zip)
    if [ -d ${FIGLET_DIR} ]; then
      cd ${FIGLET_DIR} || echo "Could not enter ${FIGLET_DIR}"
      ${ZIP} -q ${FIGLET_ZIP} ./*.flf
      ${PYFIG} -L ${FIGLET_ZIP}
      rm -f ${FIGLET_ZIP}
    fi
  fi
fi
