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
    apt install -y "${TEMP_DEB}"
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
    apt install -y "${TEMP_DEB}"
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

apt update
apt install -y jq
apt install -y fzf
apt install -y ripgrep
apt install -y bat
apt install -y lsd
apt install -y figlet
apt install -y lolcat
apt install -y xclip
apt install -y xsel
apt install -y python3
apt install -y python3-pip
apt install -y python3-venv
apt install -y uuid-runtime
apt install -y libaa-bin
apt install -y libaa1
apt install -y bb
apt install -y dconf-cli
apt install -y libncurses-dev
apt install -y libjpeg-dev
apt install -y libpng-dev
apt install -y khard
apt install -y git
apt install -y mplayer
apt install -y libportaudio2
apt install -y libportaudiocpp0
apt install -y portaudio19-dev
apt install -y golang
apt install -y bsdgames
apt install -y greed
apt install -y nudoku
apt install -y node
apt install -y dialog
apt install -y ranger
apt install -y tmux
apt install -y w3m
apt install -y asciinema
apt install -y gnupg
apt install -y zip
apt install -y imagemagick
apt install -y cmatrix
apt install -y neomutt
apt install -y newsboat
apt install -y speedtest-cli
apt install -y neofetch
apt install -y wl-clipboard

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
