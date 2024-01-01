ARG BASE_TAG="ubuntu-jammy"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update && apt-get install -y tmux screen nano dnsutils zip && \
    echo "set -g mouse on" > $HOME/.tmux.conf && chown 1000:1000  $HOME/.tmux.conf

### Update .zshrc to run an arbitrary command if specified as an environment variable
RUN echo "if [ ! -z \"\${SHELL_EXEC}\" ] && [ \"\${TERM}\" == \"xterm-256color\" ] ; \n\
then \n\
    set +e \n\
    eval \${SHELL_EXEC} \n\
fi  " >> $HOME/.zshrc && chown 1000:1000  $HOME/.zshrc

COPY ./src/ubuntu/install/jammy $INST_SCRIPTS/jammy/
COPY ./src/ubuntu/install/kitty $INST_SCRIPTS/kitty/
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/install_kasm_user.sh
COPY ./src/ubuntu/install/kitty/custom_startup.sh $STARTUPDIR/custom_startup.sh

RUN bash $INST_SCRIPTS/install_kasm_user.sh kitty && \
    chmod 755 $STARTUPDIR/custom_startup.sh && \
    cp /usr/share/backgrounds/Earth-Galaxy-Space.png $HOME/.local/share/backgrounds/bg_default.png && \
    rm -f $HOME/bin/postinstall && \
    rm -f $HOME/.config/autostart/postinstall.desktop && \
    chown 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

# Customize kasm-user HOME
USER 1000
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"

RUN bash ${INST_SCRIPTS}/jammy/install_user_utils.sh

######### End Customizations ###########

USER root

RUN update-desktop-database && rm -rf $INST_SCRIPTS

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
