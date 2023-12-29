ARG BASE_TAG="ubuntu-jammy"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update && apt-get install -y tmux screen nano dnsutils zip

RUN echo "set -g mouse on" > $HOME/.tmux.conf && chown 1000:1000  $HOME/.tmux.conf

### Update .zshrc to run an arbitrary command if specified as an environment variable
RUN echo "if [ ! -z \"\${SHELL_EXEC}\" ] && [ \"\${TERM}\" == \"xterm-256color\" ] ; \n\
then \n\
    set +e \n\
    eval \${SHELL_EXEC} \n\
fi  " >> $HOME/.zshrc && chown 1000:1000  $HOME/.zshrc

### Install Ansible
COPY ./src/ubuntu/install/ansible $INST_SCRIPTS/ansible/
RUN bash $INST_SCRIPTS/ansible/install_ansible.sh  && rm -rf $INST_SCRIPTS/ansible/

### Install Terraform
COPY ./src/ubuntu/install/terraform $INST_SCRIPTS/terraform/
RUN bash $INST_SCRIPTS/terraform/install_terraform.sh  && rm -rf $INST_SCRIPTS/terraform/

### Install kasm-user home
COPY ./src/ubuntu/install/kitty $INST_SCRIPTS/kitty/
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/install_kasm_user.sh
RUN bash $INST_SCRIPTS/install_kasm_user.sh kitty && \
    rm -rf $INST_SCRIPTS/kitty/ && \
    rm -f $INST_SCRIPTS/install_kasm_user.sh

COPY ./src/ubuntu/install/terminal/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

# Customize kasm-user HOME
USER 1000
ENV HOME /home/kasm-user
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"

RUN chmod 755 ${HOME}/bin/* && \
    ${HOME}/bin/install-kitty && \
    [ -f $HOME/.local/share/applications/kitty.desktop ] && { \
      cp $HOME/.local/share/applications/kitty.desktop \
         $HOME/Desktop/kitty.desktop \
    } && \
    [ -f $HOME/.local/share/icons/hicolor/256x256/apps/kitty.png ] && { \
      cp $HOME/.local/share/icons/hicolor/256x256/apps/kitty.png \
         $HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png \
    } && \
    [ -f $HOME/.local/share/icons/hicolor/128x128/apps/kitty.png ] && { \
      cp $HOME/.local/share/icons/hicolor/128x128/apps/kitty.png \
         $HOME/.local/kitty.app/lib/kitty/logo/kitty-128.png \
    } && \
    [ -f $HOME/.local/share/icons/hicolor/32x32/apps/kitty.png ] && { \
      cp $HOME/.local/share/icons/hicolor/32x32/apps/kitty.png \
         $HOME/.local/kitty.app/lib/kitty/logo/kitty.png \
    } && \
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    python3 -m pip install --user Pillow && \
    python3 -m pip install --user Pygments && \
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install && \
    git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus && \
    [ -f ${HOME}/.config/obsidian.tar.gz ] && { \
      tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config \
      rm -f ${HOME}/.config/obsidian.tar.gz \
    } && \
    [ -f ${HOME}/.config/dotobsidian.tar.gz ] && { \
      [ -d ${HOME}/Documents/cheat-sheets-plus ] && { \
        tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus \
      } \
      rm -f ${HOME}/.config/dotobsidian.tar.gz \
    } && \
    [ -f ${HOME}/.config/_obs-cli ] && { \
      [ -d ${HOME}/.oh-my-zsh/completions ] || mkdir -p ${HOME}/.oh-my-zsh/completions \
      cp ${HOME}/.config/_obs-cli ${HOME}/.oh-my-zsh/completions/_obs-cli \
      rm -f ${HOME}/.config/_obs-cli \
    } && \
    xdg-mime default obsidian.desktop x-scheme-handler/obsidian && \
    [ -x /usr/local/bin/obs-cli ] && { \
      /usr/local/bin/obs-cli set-default cheat-sheets-plus > /dev/null 2>&1 \
    } && \
    vim +PlugInstall +qall > /dev/null 2>&1 && \
    [ -f $HOME/.local/share/applications/btop.desktop ] && { \
      cp $HOME/.local/share/applications/btop.desktop \
         $HOME/Desktop/btop.desktop \
    } && \
    chmod 755 ${HOME} && \
    chmod 644 ${HOME}/.aliases ${HOME}/.bashrc ${HOME}/.zshrc && \
    for fdir in launchpadlib mozilla vim \
    do \
      [ -d ${HOME}/.${fdir} ] && { \
        find ${HOME}/.${fdir} -type f | xargs chmod 644 \
        find ${HOME}/.${fdir} -type d | xargs chmod 755 \
      } \
    done && \
    find ${HOME}/.vim -type f -print0 | xargs -0 grep -l /usr/bin/env | while read f \
    do \
      chmod 755 $f \
    done && \
    find ${HOME}/.config -type d | xargs chmod 755 && \
    for cdir in ${HOME}/.config/* \
    do \
      [ "${cdir}" == "${HOME}/.config/*" ] && continue \
      [ "${cdir}" == "${HOME}/.config/nvim-Lazyman" ] && continue \
      [ "${cdir}" == "${HOME}/.config/autostart" ] && continue \
      find ${cdir} -type f | xargs chmod 644 \
    done && \
    chmod 600 ${HOME}/.config/user-dirs.* && \
    find ${HOME}/go -type d | xargs chmod 755 && \
    find ${HOME}/go/pkg -type f | xargs chmod 644 && \
    chmod 755 ${HOME}/go/bin/* && \
    find ${HOME}/.local -type d | xargs chmod 755 && \
    find ${HOME}/.local/share/icons -type f | xargs chmod 644 && \
    find ${HOME}/.oh-my-zsh -type d | xargs chmod 755 && \
    find ${HOME}/.oh-my-zsh -perm 666 | xargs chmod 644 && \
    find ${HOME}/.oh-my-zsh -perm 777 | xargs chmod 755 && \
    chmod 755 ${HOME}/.config/ranger/*.sh && \
    chmod 755 ${HOME}/Desktop && \
    chmod 755 ${HOME}/Desktop/* && \
    chmod 755 ${HOME}/.local/share/applications/*.desktop && \
    chmod 755 ${HOME}/bin && \
    chmod 755 ${HOME}/bin/* && \
    chmod 755 ${HOME}/.cargo && \
    chmod 755 ${HOME}/logs && \
    [ -d ${HOME}/.cache ] || mkdir ${HOME}/.cache && \
    chmod 755 ${HOME}/.cache && \
    [ -d ${HOME}/.cache/mozilla ] || mkdir ${HOME}/.cache/mozilla && \
    chmod 755 ${HOME}/.cache/mozilla && \
    [ -d ${HOME}/.mozilla ] || mkdir ${HOME}/.mozilla && \
    chmod 755 ${HOME}/.mozilla && \
    [ -d ${HOME}/.mozilla/firefox ] || mkdir ${HOME}/.mozilla/firefox && \
    chmod 755 ${HOME}/.mozilla/firefox && \
    [ -d ${HOME}/.pki ] || mkdir ${HOME}/.pki && \
    chmod 700 ${HOME}/.pki && \
    [ -d ${HOME}/.pki/nssdb ] || mkdir ${HOME}/.pki/nssdb && \
    chmod 700 ${HOME}/.pki/nssdb && \
    for nss in ${HOME}/.pki/nssdb/* \
    do \
      [ "${nss}" == "${HOME}/.pki/nssdb/*" ] && continue \
      [ -d "${nss}" ] && chmod 700 "${nss}" \
      [ -f "${nss}" ] && chmod 600 "${nss}" \
    done && \
    [ -f ${HOME}/.pki/nssdb/pkcs11.txt ] && { \
      cat ${HOME}/.pki/nssdb/pkcs11.txt | sed -e "s/kasm-default-profile/kasm-user/g" > /tmp/k$$ \
      cp /tmp/k$$ ${HOME}/.pki/nssdb/pkcs11.txt \
      rm -f /tmp/k$$ \
    }

######### End Customizations ###########

USER root

RUN update-desktop-database

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000

CMD ["--tail-log"]
