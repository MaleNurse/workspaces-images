#!/usr/bin/env bash
set -ex

export PATH="$HOME/.local/bin:$PATH:$HOME/.cargo/bin"

# GH_TOKEN, a GitHub token must be set in the environment
export GH_TOKEN="__GITHUB_API_TOKEN__"

[ -d $HOME/.local ] || mkdir -p $HOME/.local

have_cargo=$(type -p cargo)

cargo_install() {
  [ "${have_cargo}" ] || {
    printf "\nInstalling cargo ..."
    RUST_URL="https://sh.rustup.rs"
    curl -fsSL -H "Authorization: Bearer ${GH_TOKEN}" "${RUST_URL}" >/tmp/rust-$$.sh
    [ $? -eq 0 ] || {
      curl -kfsSL -H "Authorization: Bearer ${GH_TOKEN}" "${RUST_URL}" >/tmp/rust-$$.sh
      [ -f /tmp/rust-$$.sh ] && {
        cat /tmp/rust-$$.sh | sed -e "s/--show-error/--insecure --show-error/" >/tmp/ins$$
        cp /tmp/ins$$ /tmp/rust-$$.sh
        rm -f /tmp/ins$$
      }
    }
    [ -f /tmp/rust-$$.sh ] && sh /tmp/rust-$$.sh -y >/dev/null 2>&1
    rm -f /tmp/rust-$$.sh
    have_cargo=$(type -p cargo)
  }
  if [ "${have_cargo}" ]
  then
    printf "\nBuilding Neovide GUI, please be patient ... "
    cargo install --git https://github.com/neovide/neovide >/dev/null 2>&1
    have_neovide=$(type -p neovide)
  else
    printf "\nCannot locate cargo. Perhaps it is not in your PATH."
    printf "\nUnable to build Neovide\n"
  fi
}

dl_asset() {
  name="neovide"
  format="tar"
  suffix="gz"

  OWNER="neovide"
  PROJECT="neovide"
  API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent -H "Authorization: Bearer ${GH_TOKEN}" "${API_URL}" \
      | jq --raw-output '.assets | .[]?.browser_download_url' \
      | grep "${name}\.${format}\.${suffix}$")
  [ "${DL_URL}" ] && {
    printf "\nDownloading neovide release asset ..."
    if [ "${DLFMT}" == "tgz" ]
    then
      TEMP_ASS="$(mktemp --suffix=.tgz)"
    else
      TEMP_ASS="$(mktemp --suffix=.zip)"
    fi
    wget --quiet -O "${TEMP_ASS}" "${DL_URL}" >/dev/null 2>&1
    chmod 644 "${TEMP_ASS}"
    mkdir -p /tmp/neov$$
    if [ "${DLFMT}" == "tgz" ]
    then
      tar -C /tmp/neov$$ -xzf "${TEMP_ASS}"
    else
      unzip -d /tmp/neov$$ "${TEMP_ASS}"
    fi
    [ -f /tmp/neov$$/neovide ] && {
      chmod 755 /tmp/neov$$/neovide
      /tmp/neov$$/neovide --version > /dev/null 2>&1 && {
        rm -f /tmp/neovide$$
        mv /tmp/neov$$/neovide /tmp/neovide$$
      }
    }
    [ -f /tmp/neov$$/neovide.dmg ] && {
      chmod 644 /tmp/neov$$/neovide.dmg
      rm -f /tmp/neovide$$.dmg
      mv /tmp/neov$$/neovide.dmg /tmp/neovide$$.dmg
    }
    rm -f "${TEMP_ASS}"
    rm -rf /tmp/neov$$
    printf " done"
  }
}

have_neovide=$(command -v neovide)
[ "${have_neovide}" ] && {
  printf "\nNeovide already installed as %s" "${have_neovide}"
  printf "\nRemove neovide and rerun this script to reinstall Neovide"
}
[ -d "$HOME"/.local ] || mkdir -p "$HOME"/.local
[ -d "$HOME"/.local/bin ] || mkdir -p "$HOME"/.local/bin
dl_asset
if [ -x /tmp/neovide$$ ]
then
  mv /tmp/neovide$$ "$HOME"/.local/bin/neovide
else
  cargo_install
fi

chown -R 1000:1000 $HOME/.local/bin
