#!/usr/bin/env bash
#

OWNER=doctorfree

install_musicplayerplus() {
  API_URL="https://api.github.com/repos/${OWNER}/MusicPlayerPlus/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling MusicPlayerPlus ..."
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

# GH_TOKEN, a GitHub token must be set in the environment
export GH_TOKEN="__GITHUB_API_TOKEN__"

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

apt-get update
apt-get install -y apt-utils
apt-get install -y jq
apt-get install -y fzf
apt-get install -y ripgrep
apt-get install -y bat
apt-get install -y lsd
apt-get install -y figlet
apt-get install -y lolcat
apt-get install -y libnotify-bin
apt-get install -y xclip
apt-get install -y xsel
apt-get install -y python3
apt-get install -y python3-pip
apt-get install -y python3-venv
apt-get install -y uuid-runtime
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
apt-get install -y dialog
apt-get install -y ranger
apt-get install -y tmux
apt-get install -y w3m
apt-get install -y gnupg
apt-get install -y zip
apt-get install -y imagemagick
apt-get install -y neofetch
apt-get install -y wl-clipboard
apt-get install -y pulseaudio
apt-get install -y python3-gst-1.0
apt-get install -y gir1.2-gstreamer-1.0
apt-get install -y gir1.2-gst-plugins-base-1.0
apt-get install -y gstreamer1.0-plugins-good
apt-get install -y gstreamer1.0-plugins-ugly
apt-get install -y gstreamer1.0-tools

install_musicplayerplus

# Install mppcava and mpcplus if not already present
PROJECT=mppcava
install_external_package
PROJECT=mpcplus
install_external_package
PROJECT=mpplus-essentia
install_external_package
PROJECT=mpplus-bliss
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

# User needs to be in group adm for some systemctl actions
usermod -aG adm kasm-user

# Install Navidrome
user=1000
group=1000
mach="X86_64"
navivar="/var/lib/navidrome"
navi_version="0.50.1"

if [ -x /opt/navidrome/navidrome ]; then
  echo "Existing Navidrome installation detected. Skipping Navidrome install."
else
  install -d -o ${user} -g ${group} /opt/navidrome
  install -d -o ${user} -g ${group} ${navivar}

  NAVI_URL="https://github.com/navidrome/navidrome/releases/download"
  NAVI_NAM="v${navi_version}/navidrome_${navi_version}_Linux_${mach}.tar.gz"
  wget --quiet -O ${navivar}/Navidrome.tar.gz ${NAVI_URL}/${NAVI_NAM}

  if [ -f "${navivar}/Navidrome.tar.gz" ]; then
    tar -xzf ${navivar}/Navidrome.tar.gz -C /opt/navidrome/
    rm -f "${navivar}/Navidrome.tar.gz"
    chown -R ${user}:${group} /opt/navidrome
  else
    echo "Navidrome download failed."
    echo "Could not locate ${navivar}/Navidrome.tar.gz"
    echo ""
    echo "Visit https://github.com/navidrome/navidrome/releases/download/"
    echo "and locate the latest Navidrome release for this platform (${mach})."
    echo ""
    echo "Download the Navidrome release 'tar.gz' and move it to:"
    echo "    ${navivar}/Navidrome.tar.gz"
    echo "Then re-run the 'mppinit navidrome' command."
    echo ""
    echo "Exiting without installing or configuring Navidrome."
  fi
fi

systemctl disable pulseaudio.service >/dev/null 2>&1
systemctl disable pulseaudio.socket >/dev/null 2>&1
systemctl stop pulseaudio.service >/dev/null 2>&1
systemctl stop pulseaudio.socket >/dev/null 2>&1
systemctl --quiet disable mpd.service >/dev/null 2>&1
systemctl --quiet disable mpd.socket >/dev/null 2>&1
systemctl --quiet stop mpd.service >/dev/null 2>&1
systemctl --quiet stop mpd.socket >/dev/null 2>&1
