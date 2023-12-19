#!/usr/bin/env bash
set -ex

mkdir -p $HOME/.config

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"

cp ${SCRIPT_PATH}/dotobsidian.tar.gz $HOME/.config
cp ${SCRIPT_PATH}/obsidian.tar.gz $HOME/.config

chown 1000:1000 $HOME/.config/*.gz
