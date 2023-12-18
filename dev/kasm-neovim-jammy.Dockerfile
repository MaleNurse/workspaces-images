ARG BASE_TAG="develop"
ARG BASE_IMAGE="ubuntu-jammy-desktop"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND noninteractive
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV INST_SCRIPTS $STARTUPDIR/install
ENV DONT_PROMPT_WSL_INSTALL "No_Prompt_please"

# Add Kasm Branding
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN cp /usr/share/extra/icons/icon_kasm.png /usr/share/extra/icons/icon_default.png
RUN sed -i 's/ubuntu-mono-dark/elementary-xfce/g' $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

### Install Neovim dependencies and user config
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/
COPY ./src/ubuntu/install/neovim-jammy $INST_SCRIPTS/neovim-jammy/
RUN \
  bash $INST_SCRIPTS/neovim-jammy/install_tools_neovim.sh && \
  bash $INST_SCRIPTS/install_kasm_user.sh neovim-jammy && \
  rm -rf $INST_SCRIPTS/neovim-jammy/ && \
  rm -f $INST_SCRIPTS/install_kasm_user.sh

#ADD ./src/common/scripts $STARTUPDIR
RUN $STARTUPDIR/set_user_permission.sh $HOME

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
