#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
DEST="/usr/share/backgrounds"

umask 022

# Copy all images in the backgrounds folder
[ -d ${DEST} ] || mkdir -p ${DEST}
for bg in ${SCRIPT_PATH}/*.png ${SCRIPT_PATH}/*.jpg
do
  [ "${bg}" == "${SCRIPT_PATH}/*.png" ] && continue
  [ "${bg}" == "${SCRIPT_PATH}/*.jpg" ] && continue
  cp ${bg} ${DEST}
  chmod 644 ${DEST}/${bg}
done
