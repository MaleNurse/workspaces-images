ARG BASE_TAG="ubuntu-jammy"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_DIR $STARTUPDIR/install
ENV DONT_PROMPT_WSL_INSTALL "No_Prompt_please"
WORKDIR $HOME

######### Customize Container Here ###########

# Copy install scripts
COPY ./src/ $INST_DIR

RUN  TEMP_DEB="$(mktemp).deb" \
        && add-apt-repository ppa:pipewire-debian/pipewire-upstream \
        && apt-get -f install libxcb-randr0 libxdo3 gstreamer1.0-pipewire -y \
        && LATESTURL="$(curl -f -L https://github.com/rustdesk/rustdesk/releases/latest | grep -Eo 'https://[a-zA-Z0-9#~.*,/!?=+&_%:-]*-x86_64.deb')" \
        && wget -O $TEMP_DEB $LATESTURL \
        && apt install -f $TEMP_DEB -y \
        && rm -f "$TEMP_DEB" \
        && rm -rf ${HOME}/.mozilla \
        && bash $INST_DIR/ubuntu/install/install_kasm_user.sh rustdesk \
        && $STARTUPDIR/set_user_permission.sh $HOME \
        && rm -f /etc/X11/xinit/Xclients \
        && chown 1000:0 $HOME \
        && mkdir -p /home/kasm-user \
        && chown -R 1000:0 /home/kasm-user \
        && chsh -s /bin/zsh kasm-user

# Userspace Runtime
ENV HOME /home/kasm-default-profile
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"
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
