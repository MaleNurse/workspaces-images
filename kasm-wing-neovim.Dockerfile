ARG BASE_TAG="neovim"
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
    INST_SCRIPTS="/ubuntu/install/sublime_text/install_sublime_text.sh \
                  /ubuntu/install/vs_code/install_vs_code.sh \
                  /ubuntu/install/wing-neovim/install_tools_wing.sh \
                  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  rm -rf ${HOME}/.mozilla && \
  bash ${INST_DIR}/ubuntu/install/install_kasm_user.sh wing-neovim && \
  cp /usr/share/backgrounds/Earth-Galaxy-Space.png $HOME/.local/share/backgrounds/bg_default.png && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  chsh -s /bin/zsh kasm-user

# Publishing this port in docker_run_config enables browser access to
# Wing console from outside the container - http://<ip-address>:3000
EXPOSE 3000

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
