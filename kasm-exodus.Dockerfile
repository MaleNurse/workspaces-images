ARG BASE_TAG="develop"
ARG BASE_IMAGE="ubuntu-jammy-desktop"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

### Envrionment config
ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV DEBIAN_FRONTEND noninteractive
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV DONT_PROMPT_WSL_INSTALL "No_Prompt_please"
WORKDIR $HOME

# Add Kasm Branding
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN cp /usr/share/extra/icons/icon_kasm.png /usr/share/extra/icons/icon_default.png
RUN sed -i 's/ubuntu-mono-dark/elementary-xfce/g' $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

### Install user config and dependencies
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/
COPY ./src/ubuntu/install/exodus/ $INST_SCRIPTS/
RUN \
  bash $INST_SCRIPTS/exodus/install_tools_exodus.sh && \
  bash $INST_SCRIPTS/install_kasm_user.sh exodus && \
  rm -f $INST_SCRIPTS/install_kasm_user.sh && \
  rm -rf $INST_SCRIPTS/exodus

######### Customize Container Here ###########

COPY ./src/ubuntu/install/exodus/exodus-linux-x64.deb /home/kasm-default-profile

RUN dpkg -i exodus-linux-x64.deb \
    && cp /usr/share/applications/exodus.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/exodus.desktop \
    && chown 1000:1000 $HOME/Desktop/exodus.desktop

# Clean up
RUN rm /home/kasm-default-profile/exodus-linux-x64.deb


RUN $STARTUPDIR/set_user_permission.sh $HOME

RUN chown -R 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
