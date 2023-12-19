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

# GH_TOKEN, a GitHub token must be set in the environment
export GH_TOKEN="__GITHUB_API_TOKEN__"

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

add-apt-repository universe
add-apt-repository ppa:appimagelauncher-team/stable
apt-get update
apt-get install -y libfuse2
apt-get install -y appimagelauncher

install_fzf
