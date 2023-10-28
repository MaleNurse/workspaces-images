#!/usr/bin/env bash
set -ex
apt-get update
apt-get install -y curl jq tar unzip fzf wget xclip wl-clipboard wl-copy \
                   ripgrep luarocks julia php composer ccls bat lsd figlet \
                   luarocks lolcat xsel python3 python3-venv ruby ruby-dev
