#!/bin/bash
#
export HOME=/home/kasm-default-profile
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
export NVM_DIR="$HOME/.nvm"

rm -rf ${NVM_DIR}
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
[ -f ${NVM_DIR}/nvm.sh ] && {
  . ${NVM_DIR}/nvm.sh
  nvm install -b --lts
  nvm alias default node
  nvm use default
}

sh -c \
  "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  "" --unattended --keep-zshrc --skip-chsh
git clone https://github.com/romkatv/powerlevel10k.git \
    $ZSH_CUSTOM/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions \
    ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/redxtech/zsh-kitty \
    ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-kitty
git clone https://github.com/Aloxaf/fzf-tab \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
/usr/local/go/bin/go install github.com/charmbracelet/glow@latest
chmod 755 ${HOME}/bin/install-kitty
${HOME}/bin/install-kitty
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
python3 -m pip install --user Pillow
python3 -m pip install --user Pygments
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install --all
sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.bash
sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.zsh
git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus
git clone https://github.com/doctorfree/Pokedex-Markdown.git ${HOME}/Documents/Pokedex-Markdown
tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config
rm -f ${HOME}/.config/obsidian.tar.gz
tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus
rm -f ${HOME}/.config/dotobsidian.tar.gz
tar xzf ${HOME}/.config/pokedex-markdown.tar.gz -C ${HOME}/Documents/Pokedex-Markdown
rm -f ${HOME}/.config/pokedex-markdown.tar.gz
mkdir -p ${HOME}/.oh-my-zsh/completions
cp ${HOME}/.config/_obs-cli ${HOME}/.oh-my-zsh/completions/_obs-cli
rm -f ${HOME}/.config/_obs-cli
xdg-mime default obsidian.desktop x-scheme-handler/obsidian
/usr/local/bin/obs-cli set-default cheat-sheets-plus
vim +PlugInstall +qall
chmod 755 ${HOME}
chmod 644 ${HOME}/.aliases ${HOME}/.bashrc ${HOME}/.zshrc
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
find ${HOME}/.oh-my-zsh -type d -print0 | xargs -0 chmod 755
find ${HOME}/.oh-my-zsh -perm 666 -print0 | xargs -0 chmod 644
find ${HOME}/.oh-my-zsh -perm 777 -print0 | xargs -0 chmod 755
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
