ARG BASE_TAG="ubuntu-jammy"
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
        https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh \
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
    && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu jammy-cran40/" \
    && apt install -y --no-install-recommends gdebi-core r-base \
    # RStudio Server
    && wget -O /tmp/rstudio-server.deb \
        https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.0-369-amd64.deb \
    && gdebi --n /tmp/rstudio-server.deb \
    && rm -f /tmp/rstudio-server.deb \
    # RStudio
    && wget -O /tmp/rstudio-desktop.deb \
        https://download1.rstudio.org/electron/jammy/amd64/rstudio-2023.12.0-369-amd64.deb \
    && gdebi --n /tmp/rstudio-desktop.deb \
    && rm -f /tmp/rstudio-desktop.deb \
    && cp /usr/share/applications/rstudio.desktop $HOME/Desktop/ \
    && chmod +x $HOME/Desktop/*.desktop \
    # Install Chrome
    && bash $INST_DIR/chrome/install_chrome.sh \
    # Install MS Edge
    && bash $INST_DIR/edge/install_edge.sh \
    && bash $INST_DIR/install_kasm_user.sh jupyter \
    && chown -R 1000:0 $HOME \
    && rm -rf $INST_DIR/

COPY ./src/ubuntu/install/jupyter/post_run_root.sh /dockerstartup/kasm_post_run_root.sh

# Install example packages in the conda environment
USER 1000
RUN bash -c "source /opt/anaconda3/bin/activate \
    && conda activate \
    && pip install \
        folium \
        pgeocode \
    && conda install -c conda-forge \
        basemap \
        matplotlib"

######### END CUSTOMIZATIONS ########

ENV HOME /home/kasm-user
WORKDIR $HOME

CMD ["--tail-log"]
