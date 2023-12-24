#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
DEST="/usr/share/backgrounds"

umask 022

# Copy all images in the backgrounds folder
[ -d ${DEST} ] || mkdir -p ${DEST}
for bg in ${SCRIPT_PATH}/*.png
do
  [ "${bg}" == "${SCRIPT_PATH}/*.png" ] && continue
  cp ${bg} ${DEST}
  chmod 644 ${DEST}/${bg}
done
[ -f ${DEST}/Earth-Galaxy-Space.png ] && {
  [ -d ${HOME}/.local/share/backgrounds ] || {
    mkdir -p ${HOME}/.local/share/backgrounds
  }
  ln -s ${DEST}/Earth-Galaxy-Space.png \
     ${HOME}/.local/share/backgrounds/bg_default.png
}
