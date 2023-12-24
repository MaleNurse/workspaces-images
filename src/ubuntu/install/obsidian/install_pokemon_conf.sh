#!/usr/bin/env bash
set -ex

mkdir -p $HOME/.config

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"

cp ${SCRIPT_PATH}/dotobsidian.tar.gz $HOME/.config
cp ${SCRIPT_PATH}/pokemon/pokedex-markdown.tar.gz $HOME/.config
cp ${SCRIPT_PATH}/pokemon/obsidian.tar.gz $HOME/.config
cp ${SCRIPT_PATH}/_obs-cli $HOME/.config

chown 1000:1000 $HOME/.config/*.gz
chown 1000:1000 $HOME/.config/_obs-cli
