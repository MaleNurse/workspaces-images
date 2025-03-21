ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-noble"
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
                  /ubuntu/install/vs_code/install_vs_code.sh \
                  /ubuntu/install/firefox/install_firefox.sh \
                  /ubuntu/install/discord/install_discord.sh \
                  /ubuntu/install/remmina/install_remmina.sh \
                  /ubuntu/install/libre_office/install_libre_office.sh \
                  /ubuntu/install/signal/install_signal.sh \
                  /ubuntu/install/audacity/install_audacity.sh \
                  /ubuntu/install/gimp/install_gimp.sh \
                  /ubuntu/install/kitty/install_kitty.sh \
                  /ubuntu/install/telegram/install_telegram.sh \
                  /ubuntu/install/zoom/install_zoom.sh \
                  /ubuntu/install/thunderbird/install_thunderbird.sh \
                  /ubuntu/install/noble/install_tools_noble.sh \
                  /ubuntu/install/torbrowser/install_torbrowser.sh \
                  /ubuntu/install/github_desktop/install_github_desktop.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Copy custom fonts, wallpapers, apps
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
  wget -O /tmp/fonts.tar.gz \
    https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/fonts/JetBrainsMonoNerdFont.tar.gz && \
  tar xzf /tmp/fonts.tar.gz -C /usr/share/fonts && \
  rm -f /tmp/fonts.tar.gz && \
  fc-cache -f

# Update base OS
RUN apt-get update && apt-get -y dist-upgrade

# Run installers
RUN for SCRIPT in $INST_SCRIPTS; do \
  bash ${INST_DIR}${SCRIPT}; \
  done

# Setup desktop user environment
RUN rm -rf ${HOME}/.mozilla && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh noble && \
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

RUN bash ${INST_DIR}/ubuntu/install/noble/install_user_utils.sh

######### End Customizations ###########

USER root

RUN update-desktop-database && \
    rm -Rf ${INST_DIR}

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
