ARG BASE_TAG="latest"
ARG BASE_IMAGE="archlinux"
FROM iterait/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-user
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV SKIP_CLEAN=true \
    KASM_RX_HOME=$STARTUPDIR/kasmrx \
    DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
    INST_DIR=$STARTUPDIR/install \
    INST_SCRIPTS="/archlinux/install/archlinux/install_tools_archlinux.sh \
                  /archlinux/install/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
    bash ${INST_DIR}${SCRIPT}; \
  done && \
  bash ${INST_DIR}/archlinux/install/install_kasm_user.sh archlinux && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/kasm-user
WORKDIR $HOME
USER 1000
