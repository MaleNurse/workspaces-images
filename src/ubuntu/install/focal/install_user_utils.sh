#!/bin/bash
#
export HOME=/home/kasm-default-profile
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

rm -rf ${NVM_DIR}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
[ -f ${NVM_DIR}/nvm.sh ] && {
  . ${NVM_DIR}/nvm.sh
  nvm install -b --lts
  nvm alias default node
  nvm use default
}

/usr/local/go/bin/go install github.com/charmbracelet/glow@latest
chmod 755 ${HOME}/bin/install-kitty
${HOME}/bin/install-kitty
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
python3 -m pip install --user Pillow
python3 -m pip install --user Pygments
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install
sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.bash
git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus
tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config
rm -f ${HOME}/.config/obsidian.tar.gz
tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus
rm -f ${HOME}/.config/dotobsidian.tar.gz
rm -f ${HOME}/.config/_obs-cli
xdg-mime default obsidian.desktop x-scheme-handler/obsidian
/usr/local/bin/obs-cli set-default cheat-sheets-plus
vim +PlugInstall +qall
chmod 755 ${HOME}
chmod 644 ${HOME}/.aliases ${HOME}/.bashrc
for fdir in launchpadlib mozilla vim
do
  [ -d ${HOME}/.${fdir} ] && {
    find ${HOME}/.${fdir} -type f -print0 | xargs -0 chmod 644
    find ${HOME}/.${fdir} -type d -print0 | xargs -0 chmod 755
  }
done
find ${HOME}/Documents -type f -print0 | xargs -0 chmod 644
find ${HOME}/Documents -type d -print0 | xargs -0 chmod 755
[ -d ${HOME}/.vim ] && {
  find ${HOME}/.vim -type f -print0 | xargs -0 grep -l /usr/bin/env | while read f
  do
    chmod 755 $f
  done
}
find ${HOME}/.config -type d -print0 | xargs -0 chmod 755
for cdir in ${HOME}/.config/*
do
  [ "${cdir}" == "${HOME}/.config/*" ] && continue
  [ -d ${cdir} ] && {
    find ${cdir} -type f -print0 | xargs -0 chmod 644
  }
done
[ -d ${HOME}/go ] && {
  find ${HOME}/go -type d -print0 | xargs -0 chmod 755
}
[ -d ${HOME}/go/pkg ] && {
  find ${HOME}/go/pkg -type f -print0 | xargs -0 chmod 644
}
chmod 755 ${HOME}/go/bin/*
find ${HOME}/.local -type d -print0 | xargs -0 chmod 755
find ${HOME}/.local/share/icons -type f -print0 | xargs -0 chmod 644
chmod 755 ${HOME}/.config/ranger/*.sh
chmod 755 ${HOME}/Desktop
chmod 755 ${HOME}/Desktop/*
chmod 755 ${HOME}/.local/share/applications/*.desktop
chmod 755 ${HOME}/bin
chmod 755 ${HOME}/bin/*
chmod 755 ${HOME}/logs
mkdir -p ${HOME}/.cache
chmod 755 ${HOME}/.cache
mkdir -p ${HOME}/.cache/mozilla
chmod 755 ${HOME}/.cache/mozilla
mkdir -p ${HOME}/.mozilla
chmod 755 ${HOME}/.mozilla
mkdir -p ${HOME}/.mozilla/firefox
chmod 755 ${HOME}/.mozilla/firefox
mkdir -p ${HOME}/.pki
chmod 700 ${HOME}/.pki
mkdir -p ${HOME}/.pki/nssdb
chmod 700 ${HOME}/.pki/nssdb
