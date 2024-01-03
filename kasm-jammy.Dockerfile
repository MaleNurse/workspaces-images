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
  rm -rf ${INST_DIR}/ubuntu/install/backgrounds && \
  wget -O /tmp/backgrounds.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/backgrounds/backgrounds.tar.gz && \
  tar xzf /tmp/backgrounds.tar.gz -C ${INST_DIR}/ubuntu/install && \
  rm -f /tmp/backgrounds.tar.gz && \
  rm -rf ${INST_DIR}/ubuntu/install/obsidian && \
  wget -O /tmp/obsidian.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/obsidian/obsidian.tar.gz && \
  tar xzf /tmp/obsidian.tar.gz -C ${INST_DIR}/ubuntu/install && \
  rm -f /tmp/obsidian.tar.gz && \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  wget -O /tmp/fonts.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/fonts/JetBrainsMonoNerdFont.tar.gz && \
  tar xzf /tmp/fonts.tar.gz -C /usr/share/fonts && \
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
  chsh -s /bin/zsh kasm-user

# Userspace Runtime
ENV HOME /home/kasm-default-profile
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"
ENV ZSH_CUSTOM $HOME/.oh-my-zsh/custom
WORKDIR $HOME
USER 1000

RUN bash ${INST_DIR}/ubuntu/install/jammy/install_user_utils.sh

######### End Customizations ###########

USER root

RUN update-desktop-database && \
    rm -Rf ${INST_DIR}

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
