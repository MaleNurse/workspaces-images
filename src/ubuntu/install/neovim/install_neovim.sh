#!/usr/bin/env bash
set -ex

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"

export PATH=${HOME}/.local/bin:${PATH}

OWNER=neovim
PROJECT=neovim
API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
DL_URL=

# GH_TOKEN, a GitHub token must be set in the environment
[ "${GH_TOKEN}" ] || exit 0

[ -d $HOME/.local ] || mkdir -p $HOME/.local
DL_URL=$(curl --silent -H "Authorization: Bearer ${GH_TOKEN}" "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "linux64\.tar\.gz$")
if [ "${DL_URL}" ]; then
  printf "\nDownloading: ${DL_URL}\n"
  TEMP_TGZ="$(mktemp --suffix=.tgz)"
  wget --quiet -O "${TEMP_TGZ}" "${DL_URL}" >/dev/null 2>&1
  chmod 644 "${TEMP_TGZ}"
  mkdir -p /tmp/nvim$$
  tar -C /tmp/nvim$$ -xzf "${TEMP_TGZ}"
  if [ -f /tmp/nvim$$/nvim-linux64/bin/nvim ]; then
    tar -C /tmp/nvim$$/nvim-linux64 -cf /tmp/nvim-$$.tar .
    tar -C ${HOME}/.local -xf /tmp/nvim-$$.tar
    chmod 755 ${HOME}/.local/bin/nvim
  else
    for nvimbin in /tmp/"nvim$$"/*/bin/nvim /tmp/"nvim$$"/bin/nvim; do
      [ "${nvimbin}" == "/tmp/nvim$$/*/bin/nvim" ] && continue
      [ -f "${nvimbin}" ] && {
        nvimdir=$(dirname ${nvimbin})
        nvimdir=$(dirname ${nvimdir})
        tar -C ${nvimdir} -cf /tmp/nvim-$$.tar .
        tar -C ${HOME}/.local -xf /tmp/nvim-$$.tar
        chmod 755 ${HOME}/.local/bin/nvim
        break
      }
    done
  fi
  rm -f "${TEMP_TGZ}"
  rm -f /tmp/nvim-$$.tar
  rm -rf /tmp/nvim$$
else
  printf "\nUnable to locate Neovim release binary archive\n"
fi

chown -R 1000:1000 $HOME/.local/bin
