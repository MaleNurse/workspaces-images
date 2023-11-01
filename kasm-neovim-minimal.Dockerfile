ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

RUN apt-get update && apt-get install -y tmux screen nano dnsutils zip

### Update .bashrc to run an arbitrary command if specified as an environment variable
RUN echo "if [ ! -z \"\${SHELL_EXEC}\" ] && [ \"\${TERM}\" == \"xterm-256color\" ] ; \n\
then \n\
    set +e \n\
    eval \${SHELL_EXEC} \n\
fi  " >> $HOME/.bashrc && chown 1000:1000  $HOME/.bashrc

### Install Ansible
COPY ./src/ubuntu/install/ansible $INST_SCRIPTS/ansible/
RUN bash $INST_SCRIPTS/ansible/install_ansible.sh  && rm -rf $INST_SCRIPTS/ansible/

### Install Terraform
COPY ./src/ubuntu/install/terraform $INST_SCRIPTS/terraform/
RUN bash $INST_SCRIPTS/terraform/install_terraform.sh  && rm -rf $INST_SCRIPTS/terraform/

COPY ./src/ubuntu/install/neovim/install_tools_neovim.sh $INST_SCRIPTS/
RUN bash $INST_SCRIPTS/install_tools_neovim.sh && rm -f $INST_SCRIPTS/install_tools_neovim.sh
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_SCRIPTS/
RUN bash $INST_SCRIPTS/install_kasm_user.sh neovim && rm -f $INST_SCRIPTS/install_kasm_user.sh

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
