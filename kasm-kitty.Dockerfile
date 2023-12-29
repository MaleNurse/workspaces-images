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

COPY ./src/ubuntu/install/kitty $INST_SCRIPTS/kitty/
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/install_kasm_user.sh
COPY ./src/ubuntu/install/terminal/custom_startup.sh $STARTUPDIR/custom_startup.sh

RUN bash $INST_SCRIPTS/install_kasm_user.sh kitty && \
    rm -rf $INST_SCRIPTS/kitty/ && \
    rm -f $INST_SCRIPTS/install_kasm_user.sh && \
    chmod 755 $STARTUPDIR/custom_startup.sh && \
    cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/ && \
    cp /usr/share/backgrounds/Earth-Galaxy-Space.png $HOME/.local/share/backgrounds/bg_default.png && \
    apt-get remove -y xfce4-panel && \
    chown 1000:0 $HOME && \
    $STARTUPDIR/set_user_permission.sh $HOME

# Customize kasm-user HOME
USER 1000
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"

RUN chmod 755 ${HOME}/bin/install-kitty && \
    ${HOME}/bin/install-kitty && \
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    python3 -m pip install --user Pillow && \
    python3 -m pip install --user Pygments && \
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install && \
    git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus && \
    tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config && \
    rm -f ${HOME}/.config/obsidian.tar.gz && \
    tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus && \
    rm -f ${HOME}/.config/dotobsidian.tar.gz && \
    mkdir -p ${HOME}/.oh-my-zsh/completions && \
    cp ${HOME}/.config/_obs-cli ${HOME}/.oh-my-zsh/completions/_obs-cli && \
    rm -f ${HOME}/.config/_obs-cli && \
    xdg-mime default obsidian.desktop x-scheme-handler/obsidian && \
    /usr/local/bin/obs-cli set-default cheat-sheets-plus && \
    vim +PlugInstall +qall && \
    chmod 755 ${HOME} && \
    chmod 644 ${HOME}/.aliases ${HOME}/.bashrc ${HOME}/.zshrc && \
    find ${HOME}/.vim -type f -print0 | xargs -0 grep -l /usr/bin/env | while read f; do \
      chmod 755 $f; \
    done && \
    find ${HOME}/.config -type d -print0 | xargs -0 chmod 755 && \
    for cdir in ${HOME}/.config/*; do \
      find ${cdir} -type f -print0 | xargs -0 chmod 644; \
    done && \
    find ${HOME}/go -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/go/pkg -type f -print0 | xargs -0 chmod 644 && \
    chmod 755 ${HOME}/go/bin/* && \
    find ${HOME}/.local -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/.local/share/icons -type f -print0 | xargs -0 chmod 644 && \
    find ${HOME}/.oh-my-zsh -type d -print0 | xargs -0 chmod 755 && \
    find ${HOME}/.oh-my-zsh -perm 666 -print0 | xargs -0 chmod 644 && \
    find ${HOME}/.oh-my-zsh -perm 777 -print0 | xargs -0 chmod 755 && \
    chmod 755 ${HOME}/.config/ranger/*.sh && \
    chmod 755 ${HOME}/Desktop && \
    chmod 755 ${HOME}/Desktop/* && \
    chmod 755 ${HOME}/.local/share/applications/*.desktop && \
    chmod 755 ${HOME}/bin && \
    chmod 755 ${HOME}/bin/* && \
    chmod 755 ${HOME}/.cargo && \
    chmod 755 ${HOME}/logs && \
    mkdir -p ${HOME}/.cache && \
    chmod 755 ${HOME}/.cache && \
    mkdir -p ${HOME}/.cache/mozilla && \
    chmod 755 ${HOME}/.cache/mozilla && \
    mkdir -p ${HOME}/.mozilla && \
    chmod 755 ${HOME}/.mozilla && \
    mkdir -p ${HOME}/.mozilla/firefox && \
    chmod 755 ${HOME}/.mozilla/firefox && \
    mkdir -p ${HOME}/.pki && \
    chmod 700 ${HOME}/.pki && \
    mkdir -p ${HOME}/.pki/nssdb && \
    chmod 700 ${HOME}/.pki/nssdb

######### End Customizations ###########

USER root

RUN update-desktop-database

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
