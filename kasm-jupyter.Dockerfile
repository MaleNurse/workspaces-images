ARG BASE_TAG="ubuntu-focal"
ARG BASE_IMAGE="kasm"
FROM doctorwhen/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_DIR $STARTUPDIR/install
WORKDIR $HOME

######### START CUSTOMIZATION ########

COPY ./src/ubuntu/install/chrome $INST_DIR/chrome/
COPY ./src/ubuntu/install/edge $INST_DIR/edge/
COPY ./src/ubuntu/install/jupyter $INST_DIR/jupyter/
COPY ./src/ubuntu/install/install_kasm_user.sh $INST_DIR/

RUN apt-get update && apt-get install -y \
        libasound2 \
        libegl1-mesa \
        libgl1-mesa-glx \
        libxcomposite1 \
        libxcursor1 \
        libxi6 \
        libxrandr2 \
        libxrandr2 \
        libxss1 \
        libxtst6 \
    && wget -O /tmp/Anaconda3.sh \
        https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh \
    && bash /tmp/Anaconda3.sh -b -p /opt/anaconda3 \
    && rm -f /tmp/Anaconda3.sh \
    && echo 'source /opt/anaconda3/bin/activate' >> /etc/bash.bashrc \
    # Update all the conda things
    && bash -c "source /opt/anaconda3/bin/activate \
        && conda update -n root conda  \
        && conda update --all \
        && conda clean --all" \
    && /opt/anaconda3/bin/conda config --set ssl_verify /etc/ssl/certs/ca-certificates.crt \
    && /opt/anaconda3/bin/conda install pip \
    && mkdir -p /home/kasm-user/.pip \
    && chown -R 1000:1000 /opt/anaconda3 /home/kasm-default-profile/.conda/ \
    # R
    # install two helper packages we need
    && apt install --no-install-recommends software-properties-common dirmngr \
    # add the signing key (by Michael Rutter) for these repos
    # To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
    # Fingerprint: E298A3A825C0D65DFD57CBB651716619E084DAB9
    # && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    #                --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc \
    # add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" \
    && apt install -y --no-install-recommends gdebi-core r-base \
    # RStudio Server
    && wget -O /tmp/rstudio-server.deb \
        https://download2.rstudio.org/server/focal/amd64/rstudio-server-2023.12.0-369-amd64.deb \
    && gdebi --n /tmp/rstudio-server.deb \
    && rm -f /tmp/rstudio-server.deb \
    # RStudio
    && wget -O /tmp/rstudio-desktop.deb \
        https://download1.rstudio.org/electron/focal/amd64/rstudio-2023.12.0-369-amd64.deb \
    && gdebi --n /tmp/rstudio-desktop.deb \
    && rm -f /tmp/rstudio-desktop.deb \
    && cp /usr/share/applications/rstudio.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/*.desktop \
    # Install Chrome
    && bash $INST_DIR/chrome/install_chrome.sh \
    # Install MS Edge
    && bash $INST_DIR/edge/install_edge.sh \
    && bash $INST_DIR/install_kasm_user.sh jupyter \
    && cp /usr/share/backgrounds/Earth-Galaxy-Space.png $HOME/.local/share/backgrounds/bg_default.png \
    && apt-get remove -y xfce4-panel \
    && rm -f $HOME/bin/postinstall \
    && rm -f $HOME/.config/autostart/postinstall.desktop \
    && chown -R 1000:0 $HOME \
    && rm -rf $INST_DIR/

COPY ./src/ubuntu/install/jupyter/post_run_root.sh /dockerstartup/kasm_post_run_root.sh

# Install example packages in the conda environment
USER 1000
ENV PATH "$HOME/bin:$HOME/.local/bin:$PATH"

RUN bash -c "source /opt/anaconda3/bin/activate \
    && conda activate \
    && pip install \
        folium \
        pgeocode \
    && conda install -c conda-forge \
        basemap \
        matplotlib" && \
    chmod 755 ${HOME}/bin/install-kitty && \
    ${HOME}/bin/install-kitty && \
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash && \
    python3 -m pip install --user Pillow && \
    python3 -m pip install --user Pygments && \
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf && \
    $HOME/.fzf/install && \
    sed -i 's/kasm-default-profile/kasm-user/g' $HOME/.fzf.bash && \
    git clone https://github.com/doctorfree/cheat-sheets-plus ${HOME}/Documents/cheat-sheets-plus && \
    tar xzf ${HOME}/.config/obsidian.tar.gz -C ${HOME}/.config && \
    rm -f ${HOME}/.config/obsidian.tar.gz && \
    tar xzf ${HOME}/.config/dotobsidian.tar.gz -C ${HOME}/Documents/cheat-sheets-plus && \
    rm -f ${HOME}/.config/dotobsidian.tar.gz && \
    rm -f ${HOME}/.config/_obs-cli && \
    xdg-mime default obsidian.desktop x-scheme-handler/obsidian && \
    /usr/local/bin/obs-cli set-default cheat-sheets-plus && \
    vim +PlugInstall +qall && \
    chmod 755 ${HOME} && \
    chmod 644 ${HOME}/.aliases ${HOME}/.bashrc && \
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
    chmod 755 ${HOME}/.config/ranger/*.sh && \
    chmod 755 ${HOME}/Desktop && \
    chmod 755 ${HOME}/Desktop/* && \
    chmod 755 ${HOME}/.local/share/applications/*.desktop && \
    chmod 755 ${HOME}/bin && \
    chmod 755 ${HOME}/bin/* && \
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

######### END CUSTOMIZATIONS ########

ENV HOME /home/kasm-user
WORKDIR $HOME

CMD ["--tail-log"]
