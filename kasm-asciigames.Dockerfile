ARG BASE_TAG="ubuntu-jammy"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG

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
    INST_SCRIPTS="/ubuntu/install/asciigames/install_tools_asciigames.sh \
                  /ubuntu/install/obsidian/install_pokemon_conf.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  bash ${INST_DIR}/ubuntu/install/backgrounds/install_backgrounds.sh Ascii-House && \
  rm -rf ${HOME}/.mozilla && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh asciigames && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  rm -f /usr/share/extra/backgrounds/bg_default.png && \
  ln -s /home/kasm-user/.local/share/backgrounds/bg_default.png \
        /usr/share/extra/backgrounds/bg_default.png && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  chsh -s /bin/zsh kasm-user && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/kasm-user
WORKDIR $HOME
USER 1000

CMD ["--tail-log"]
