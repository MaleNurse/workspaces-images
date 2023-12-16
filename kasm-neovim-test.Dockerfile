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
                  /ubuntu/install/chromium/install_chromium.sh \
                  /ubuntu/install/firefox/install_firefox.sh \
                  /ubuntu/install/thunderbird/install_thunderbird.sh \
                  /ubuntu/install/neovim/install_tools_neovim.sh \
                  /ubuntu/install/backgrounds/install_backgrounds.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
ENV DENO_INSTALL /usr
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  sh -c "$(curl -fsSL https://deno.land/x/install/install.sh)" && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh neovim && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  chsh -s /bin/zsh kasm-user && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/kasm-default-profile
ENV ZSH_CUSTOM $HOME/.oh-my-zsh/custom
WORKDIR $HOME
USER 1000

RUN \
  bash -c \
  "$(curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh)" && \
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
  bash ${HOME}/bin/install-kitty && \
  bash ${HOME}/bin/install-neovim && \
  bash ${HOME}/bin/install-neovide && \
  git clone https://github.com/doctorfree/nvim-lazyman \
      ${HOME}/.config/nvim-Lazyman && \
  cp ${HOME}/.config/nvim-Lazyman/lazyman.sh ${HOME}/.local/bin/lazyman && \
  chmod 755 ${HOME}/.local/bin/lazyman && \
  bash ${HOME}/bin/fix-kasm-user-path

USER root

RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
USER 1000

CMD ["--tail-log"]
