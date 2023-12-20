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

# GH_TOKEN, a GitHub token must be set in the environment
export GH_TOKEN="__GITHUB_API_TOKEN__"

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

apt-get update
apt-get install -y libportaudio2
apt-get install -y libportaudiocpp0
apt-get install -y portaudio19-dev
apt-get install -y bsdgames
apt-get install -y greed
apt-get install -y nudoku
apt-get install -y speedtest-cli

install_fzf

install_asciiville

PROJECT=asciigames
install_external_package
PROJECT=any2ascii
install_external_package
PROJECT=endoh1
install_external_package
PROJECT=asciiville-aewan
install_external_package
