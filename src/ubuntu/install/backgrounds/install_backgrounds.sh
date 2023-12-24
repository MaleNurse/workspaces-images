#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
DEST="/usr/share/backgrounds"
BG="Earth-Galaxy-Space.png"

umask 022

# Copy all images in the backgrounds folder
[ -d ${DEST} ] || mkdir -p ${DEST}
for bg in ${SCRIPT_PATH}/*.png
do
  [ "${bg}" == "${SCRIPT_PATH}/*.png" ] && continue
  cp ${bg} ${DEST}
  chmod 644 ${DEST}/${bg}
done

[ "$1" ] && {
  if [ -f ${DEST}/$1 ]; then
    BG="$1"
  else
    [ -f ${DEST}/$1.png ] && BG="$1.png"
  fi
}

[ -f ${DEST}/${BG} ] && {
  [ -d ${HOME}/.local/share/backgrounds ] || {
    mkdir -p ${HOME}/.local/share/backgrounds
  }
  cp ${DEST}/${BG} \
     ${HOME}/.local/share/backgrounds/bg_default.png
}
