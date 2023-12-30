ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-jammy"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND=noninteractive \
    SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/ubuntu/install/tools/install_tools_deluxe.sh \
                  /ubuntu/install/misc/install_tools.sh \
                  /ubuntu/install/chrome/install_chrome.sh \
                  /ubuntu/install/firefox/install_firefox.sh \
                  /ubuntu/install/nextcloud/install_nextcloud.sh \
                  /ubuntu/install/remmina/install_remmina.sh \
                  /ubuntu/install/only_office/install_only_office.sh \
                  /ubuntu/install/signal/install_signal.sh \
                  /ubuntu/install/gimp/install_gimp.sh \
                  /ubuntu/install/zoom/install_zoom.sh \
                  /ubuntu/install/obs/install_obs.sh \
                  /ubuntu/install/ansible/install_ansible.sh \
                  /ubuntu/install/terraform/install_terraform.sh \
                  /ubuntu/install/telegram/install_telegram.sh \
                  /ubuntu/install/thunderbird/install_thunderbird.sh \
                  /ubuntu/install/gamepad_utils/install_gamepad_utils.sh \
                  /ubuntu/install/jammy/install_tools_jammy.sh \
                  /ubuntu/install/backgrounds/install_backgrounds.sh \
                  /ubuntu/install/obsidian/install_obsidian_conf.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  wget -O /tmp/fonts.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/fonts/JetBrainsMonoNerdFont.tar.gz && \
  tar xzf /tmp/fonts.tar.gz \
    -C /usr/share/fonts && \
  rm -f /tmp/fonts.tar.gz && \
  fc-cache -f && \
  rm -rf ${HOME}/.mozilla && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh jammy && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  cp /usr/share/backgrounds/Earth-Galaxy-Space.png $HOME/.local/share/backgrounds/bg_default.png && \
  rm -f /usr/share/extra/backgrounds/bg_default.png && \
  ln -s /home/kasm-user/.local/share/backgrounds/bg_default.png \
        /usr/share/extra/backgrounds/bg_default.png && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  chsh -s /bin/zsh kasm-user && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/kasm-default-profile
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"
ENV ZSH_CUSTOM $HOME/.oh-my-zsh/custom
WORKDIR $HOME
USER 1000

RUN \
  sh -c \
  "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  "" --unattended --keep-zshrc --skip-chsh && \
  git clone https://github.com/romkatv/powerlevel10k.git \
      $ZSH_CUSTOM/themes/powerlevel10k && \
  git clone https://github.com/zsh-users/zsh-autosuggestions \
      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
  git clone https://github.com/zsh-users/zsh-completions \
      ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions && \
  git clone https://github.com/redxtech/zsh-kitty \
      ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-kitty && \
  git clone https://github.com/Aloxaf/fzf-tab \
      ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab && \
  /usr/local/go/bin/go install github.com/charmbracelet/glow@latest && \
  chmod 755 ${HOME}/bin/install-kitty && \
    ${HOME}/bin/install-kitty && \
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    python3 -m pip install --user Pillow && \
    python3 -m pip install --user Pygments && \
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install && \
    sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.bash && \
    sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.zsh && \
    git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus && \
    tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config && \
    rm -f ${HOME}/.config/obsidian.tar.gz && \
    tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus && \
    rm -f ${HOME}/.config/dotobsidian.tar.gz && \
    mkdir -p ${HOME}/.oh-my-zsh/completions && \
    cp ${HOME}/.config/_obs-cli ${HOME}/.oh-my-zsh/completions/_obs-cli && \
    rm -f ${HOME}/.config/_obs-cli && \
    xdg-mime default obsidian.desktop x-scheme-handler/obsidian && \
    /usr/local/bin/obs-cli set-default cheat-sheets-plus && \
    vim +PlugInstall +qall && \
    chmod 755 ${HOME} && \
    chmod 644 ${HOME}/.aliases ${HOME}/.bashrc ${HOME}/.zshrc && \
    for fdir in launchpadlib mozilla vim; do \
      find ${HOME}/.${fdir} -type f -print0 | xargs -0 chmod 644; \
      find ${HOME}/.${fdir} -type d -print0 | xargs -0 chmod 755; \
    done && \
    find ${HOME}/.vim -type f -print0 | xargs -0 grep -l /usr/bin/env | while read f; do \
      chmod 755 $f; \
    done && \
    find ${HOME}/.config -type d -print0 | xargs -0 chmod 755 && \
    for cdir in ${HOME}/.config/*; do \
      find ${cdir} -type f -print0 | xargs -0 chmod 644; \
    done && \
    find ${HOME}/go -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/go/pkg -type f -print0 | xargs -0 chmod 644 && \
    chmod 755 ${HOME}/go/bin/* && \
    find ${HOME}/.local -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/.local/share/icons -type f -print0 | xargs -0 chmod 644 && \
    find ${HOME}/.oh-my-zsh -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/.oh-my-zsh -perm 666 -print0 | xargs -0 chmod 644 && \
    find ${HOME}/.oh-my-zsh -perm 777 -print0 | xargs -0 chmod 755 && \
    chmod 755 ${HOME}/.config/ranger/*.sh && \
    chmod 755 ${HOME}/Desktop && \
    chmod 755 ${HOME}/Desktop/* && \
    chmod 755 ${HOME}/.local/share/applications/*.desktop && \
    chmod 755 ${HOME}/bin && \
    chmod 755 ${HOME}/bin/* && \
    chmod 755 ${HOME}/logs && \
    mkdir -p ${HOME}/.cache && \
    chmod 755 ${HOME}/.cache && \
    mkdir -p ${HOME}/.cache/mozilla && \
    chmod 755 ${HOME}/.cache/mozilla && \
    mkdir -p ${HOME}/.mozilla && \
    chmod 755 ${HOME}/.mozilla && \
    mkdir -p ${HOME}/.mozilla/firefox && \
    chmod 755 ${HOME}/.mozilla/firefox && \
    mkdir -p ${HOME}/.pki && \
    chmod 700 ${HOME}/.pki && \
    mkdir -p ${HOME}/.pki/nssdb && \
    chmod 700 ${HOME}/.pki/nssdb

######### End Customizations ###########

USER root

RUN update-desktop-database

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
