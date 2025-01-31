#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
SCRIPT_PATH="${SCRIPT_PATH}/$1"

umask 022

# Copy in everything in the kasm user's HOME
if [ -d /home/kasm-user ]; then
  for configdir in ${SCRIPT_PATH}/kasm-user/* ${SCRIPT_PATH}/kasm-user/.??*
  do
    [ "${configdir}" == "${SCRIPT_PATH}/kasm-user/*" ] && continue
    [ "${configdir}" == "${SCRIPT_PATH}/kasm-user/.??*" ] && continue
    cfgdir=$(basename "${configdir}")
    if [ -d "${configdir}" ]; then
      if [ -d /home/kasm-user/${cfgdir} ]; then
        tar cf - -C ${SCRIPT_PATH}/kasm-user ${cfgdir} | tar xf - -C /home/kasm-user
      else
        cp -a ${configdir} /home/kasm-user
      fi
    else
      cp ${configdir} /home/kasm-user
    fi
  done
else
  [ -d ${SCRIPT_PATH}/kasm-user ] && {
    cp -a ${SCRIPT_PATH}/kasm-user /home/kasm-user
  }
fi
find /home/kasm-user -type f -print0 | xargs -0 chmod 644
find /home/kasm-user -type d -print0 | xargs -0 chmod 755
[ -d /home/kasm-user/bin ] && find /home/kasm-user/bin -type f -print0 | xargs -0 chmod 755
[ -d /home/kasm-user/.local/bin ] && find /home/kasm-user/.local/bin -type f -print0 | xargs -0 chmod 755
find /home/kasm-user -name \*\.desktop -print0 | xargs -0 chmod 755
[ -d /home/kasm-user/.cargo/bin ] && chmod 755 /home/kasm-user/.cargo/bin/*

chown -R 1000:1000 /home/kasm-user/
