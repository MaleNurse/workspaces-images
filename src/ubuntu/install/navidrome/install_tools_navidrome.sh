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

install_navidrome() {
  API_URL="https://api.github.com/repos/navidrome/navidrome/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "navidrome" | grep "linux_amd64\.tar\.gz")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling Navidrome ..."
    TEMP_TGZ="$(mktemp --suffix=.tgz)"
    wget --quiet -O "${TEMP_TGZ}" "${DL_URL}"
    chmod 644 "${TEMP_TGZ}"
    tar -xzf ${TEMP_TGZ} -C /opt/navidrome/
    chown -R ${user}:${group} /opt/navidrome
    rm -f "${TEMP_TGZ}"
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
apt-get upgrade -y
apt-get install -y libportaudio2
apt-get install -y libportaudiocpp0
apt-get install -y portaudio19-dev
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

# User needs to be in group adm for some systemctl actions
usermod -aG adm kasm-user

# Install Navidrome
user=1000
group=1000
navivar="/var/lib/navidrome"

install -d -o ${user} -g ${group} /opt/navidrome
install -d -o ${user} -g ${group} ${navivar}

install_navidrome

#systemctl disable pulseaudio.service >/dev/null 2>&1
#systemctl disable pulseaudio.socket >/dev/null 2>&1
#systemctl stop pulseaudio.service >/dev/null 2>&1
#systemctl stop pulseaudio.socket >/dev/null 2>&1
#systemctl --quiet disable mpd.service >/dev/null 2>&1
#systemctl --quiet disable mpd.socket >/dev/null 2>&1
#systemctl --quiet stop mpd.service >/dev/null 2>&1
#systemctl --quiet stop mpd.socket >/dev/null 2>&1
