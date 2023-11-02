#!/usr/bin/env bash

SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPT_PATH="$(realpath $SCRIPT_PATH)"
SCRIPT_PATH="${SCRIPT_PATH}/$1"

umask 022

[ -d $HOME ] || mkdir -p $HOME
chmod 755 $HOME
[ -f ${SCRIPT_PATH}/kasm-user/.aliases ] && {
  cp ${SCRIPT_PATH}/kasm-user/.aliases $HOME
}
[ -f ${SCRIPT_PATH}/kasm-user/.bashrc ] && {
  cp ${SCRIPT_PATH}/kasm-user/.bashrc $HOME
}
[ -f $HOME/.aliases ] && chmod 644 $HOME/.aliases
[ -f $HOME/.bashrc ] && chmod 644 $HOME/.bashrc

if [ -d $HOME/.config ]; then
  if [ -d $HOME/.config/autostart ]; then
    [ -d ${SCRIPT_PATH}/kasm-user/.config/autostart ] && {
      for autodesk in ${SCRIPT_PATH}/kasm-user/.config/autostart/*
      do
        [ "${autodesk}" == "${SCRIPT_PATH}/kasm-user/.config/autostart/*" ] && continue
        cp ${autodesk} $HOME/.config/autostart
      done
    }
  else
    [ -d ${SCRIPT_PATH}/kasm-user/.config/autostart ] && {
      cp -a ${SCRIPT_PATH}/kasm-user/.config/autostart $HOME/.config
    }
  fi
  [ -d ${SCRIPT_PATH}/kasm-user/.config/kitty ] && {
    if [ -d $HOME/.config/kitty ]; then
      tar cf - -C ${SCRIPT_PATH}/kasm-user/.config kitty | tar xf - -C $HOME/.config
    else
      cp -a ${SCRIPT_PATH}/kasm-user/.config/kitty $HOME/.config
    fi
  }
  [ -d ${SCRIPT_PATH}/kasm-user/.config/xfce4 ] && {
    if [ -d $HOME/.config/xfce4 ]; then
      tar cf - -C ${SCRIPT_PATH}/kasm-user/.config xfce4 | tar xf - -C $HOME/.config
    else
      cp -a ${SCRIPT_PATH}/kasm-user/.config/xfce4 $HOME/.config
    fi
  }
else
  [ -d ${SCRIPT_PATH}/kasm-user/.config ] && {
    cp -a ${SCRIPT_PATH}/kasm-user/.config $HOME
  }
fi
find $HOME/.config -type f | xargs chmod 644
find $HOME/.config -type d | xargs chmod 755

if [ -d $HOME/.local ]; then
  if [ -d $HOME/.local/bin ]; then
    [ -f ${SCRIPT_PATH}/kasm-user/.local/bin/lazyman ] && {
      cp ${SCRIPT_PATH}/kasm-user/.local/bin/lazyman $HOME/.local/bin
    }
  else
    [ -d ${SCRIPT_PATH}/kasm-user/.local/bin ] && {
      cp -a ${SCRIPT_PATH}/kasm-user/.local/bin $HOME/.local
    }
  fi
  [ -d ${SCRIPT_PATH}/kasm-user/.local/share ] && {
    if [ -d $HOME/.local/share ]; then
      tar cf - -C ${SCRIPT_PATH}/kasm-user/.local share | tar xf - -C $HOME/.local
    else
      cp -a ${SCRIPT_PATH}/kasm-user/.local/share $HOME/.local
    fi
  }
else
  [ -d ${SCRIPT_PATH}/kasm-user/.local ] && {
    cp -a ${SCRIPT_PATH}/kasm-user/.local $HOME
  }
fi
find $HOME/.local -type d | xargs chmod 755

[ -d ${SCRIPT_PATH}/kasm-user/Desktop ] && {
  if [ -d $HOME/Desktop ]; then
    cp ${SCRIPT_PATH}/kasm-user/Desktop/* $HOME/Desktop
  else
    cp -a ${SCRIPT_PATH}/kasm-user/Desktop $HOME
  fi
}
chmod 755 $HOME/Desktop

[ -d ${SCRIPT_PATH}/kasm-user/bin ] && {
  if [ -d $HOME/bin ]; then
    cp ${SCRIPT_PATH}/kasm-user/bin/* $HOME/bin
  else
    cp -a ${SCRIPT_PATH}/kasm-user/bin $HOME
  fi
}
[ -d $HOME/bin ] && chmod 755 $HOME/bin

[ -d ${SCRIPT_PATH}/kasm-user/.cargo ] && {
  if [ -d $HOME/.cargo ]; then
    cp ${SCRIPT_PATH}/kasm-user/.cargo/env $HOME/.cargo
  else
    cp -a ${SCRIPT_PATH}/kasm-user/.cargo $HOME
  fi
}
[ -d $HOME/.cargo ] && chmod 755 $HOME/.cargo

[ -d ${SCRIPT_PATH}/kasm-user/logs ] && {
  if [ -d $HOME/logs ]; then
    cp ${SCRIPT_PATH}/kasm-user/logs/* $HOME/logs
  else
    cp -a ${SCRIPT_PATH}/kasm-user/logs $HOME
  fi
}
[ -d $HOME/logs ] && chmod 755 $HOME/logs

chown -R 1000:1000 $HOME/
