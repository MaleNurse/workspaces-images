#!/usr/bin/env bash
set -ex

OWNER=malenurse

rm -rf /home/kasm-user/workspaces-images/src/ubuntu/install/backgrounds && \
wget -O /tmp/backgrounds.tar.gz \
  https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/backgrounds/backgrounds.tar.gz && \
tar xzf /tmp/backgrounds.tar.gz -C /home/kasm-user/workspaces-images/src/ubuntu/install && \
rm -f /tmp/backgrounds.tar.gz && \
cp /home/kasm-user/workspaces-images/src/ubuntu/install/backgrounds/Earth-Galaxy-Space.png /usr/share/backgrounds && \
rm -rf /home/kasm-user/workspaces-images/src/ubuntu/install/obsidian && \
wget -O /tmp/obsidian.tar.gz \
  https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/obsidian/obsidian.tar.gz && \
tar xzf /tmp/obsidian.tar.gz -C /home/kasm-user/workspaces-images/src/ubuntu/install && \
rm -f /tmp/obsidian.tar.gz && \
wget -O /tmp/fonts.tar.gz \
  https://raw.githubusercontent.com/wiki/doctorfree/workspaces-images/fonts/JetBrainsMonoNerdFont.tar.gz && \
tar xzf /tmp/fonts.tar.gz -C /usr/share/fonts && \
rm -f /tmp/fonts.tar.gz && \
fc-cache -f

apt-add-repository -y ppa:remmina-ppa-team/remmina-next
sed -i 's/oracular/noble/g' /etc/apt/sources.list.d/remmina-ppa-team-ubuntu-remmina-next-oracular.sources
add-apt-repository ppa:libreoffice/ppa
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'

apt-get update
apt-get install -y apt-utils
add-apt-repository universe
apt-get update
apt-get -y dist-upgrade
apt-get install -y nano zip xdotool vlc git tmux software-properties-common audacity github-desktop curl \
  jq g++ ripgrep bat figlet lolcat libnotify-bin xclip xsel python3 python3-pip python3-venv net-tools ruby ruby-dev \
  wl-clipboard uuid-runtime libaa-bin libaa1 bb dconf-cli libncurses-dev libjpeg-dev libpng-dev khard build-essential \
  git git-core file zsh fonts-powerline mplayer dialog ranger exuberant-ctags highlight neofetch catdoc pandoc w3m \
  asciinema gnupg zip imagemagick cmatrix neomutt newsboat ca-certificates

#Discord
curl -L -o discord.deb  "https://discord.com/api/download?platform=linux&format=deb"
apt-get install -y ./discord.deb
rm discord.deb
# Default config values
mkdir -p /home/kasm-user/.config/discord/
echo '{"SKIP_HOST_UPDATE": true}' > /home/kasm-user/.config/discord/settings.json
# Desktop file setup
sed -i "s@Exec=/usr/share/discord/Discord@Exec=/usr/share/discord/Discord --no-sandbox@g"  /usr/share/applications/discord.desktop
cp /usr/share/applications/discord.desktop /home/kasm-user/Desktop/
chmod +x /home/kasm-user/Desktop/discord.desktop

#Remmina
apt-get install -y remmina remmina-plugin-rdp remmina-plugin-secret remmina-plugin-spice xdotool
cp /usr/share/applications/org.remmina.Remmina.desktop /home/kasm-user/Desktop/
chmod +x /home/kasm-user/Desktop/org.remmina.Remmina.desktop
chown 1000:1000 /home/kasm-user/Desktop/org.remmina.Remmina.desktop
DEFAULT_PROFILE_DIR=/home/kasm-user/.local/share/remmina/defaults
mkdir -p $DEFAULT_PROFILE_DIR
cat >>  $DEFAULT_PROFILE_DIR/default.vnc.remmina <<EOF
[remmina]
name=vnc-connection
proxy=
disableserverbell=0
showcursor=0
disablesmoothscrolling=0
enable-autostart=1
colordepth=32
ssh_tunnel_certfile=
server=
ssh_tunnel_enabled=0
postcommand=
group=
quality=9
disableencryption=0
username=
password=
ssh_tunnel_loopback=0
disablepasswordstoring=0
ssh_tunnel_passphrase=
viewmode=4
window_maximize=0
ssh_tunnel_password=
viewonly=0
notes_text=
ssh_tunnel_privatekey=
ssh_tunnel_username=
keymap=
window_height=480
ssh_tunnel_auth=0
precommand=
window_width=640
ssh_tunnel_server=
protocol=VNC
disableserverinput=0
ignore-tls-errors=1
disableclipboard=0
EOF
cat >>  $DEFAULT_PROFILE_DIR/default.rdp.remmina <<EOF
[remmina]
disableclipboard=0
serialpath=
drive=
disable_fastpath=0
disablepasswordstoring=0
shareserial=0
password=
left-handed=0
parallelname=
gateway_password=
sharesmartcard=0
old-license=0
ssh_tunnel_loopback=0
shareprinter=0
resolution_height=0
group=
enable-autostart=0
ssh_tunnel_enabled=0
smartcardname=
gwtransp=http
domain=
serialname=
ssh_tunnel_auth=0
ssh_tunnel_server=
loadbalanceinfo=
ignore-tls-errors=1
clientname=
base-cred-for-gw=0
sound=off
freerdp_log_level=INFO
resolution_mode=2
ssh_tunnel_password=
protocol=RDP
relax-order-checks=0
gateway_username=
name=rdp-connection
usb=
preferipv6=0
dvc=
websockets=0
vc=
clientbuild=
postcommand=
restricted-admin=0
quality=0
username=
gateway_usage=0
security=
resolution_width=0
ssh_tunnel_privatekey=
rdp_reconnect_attempts=
console=0
microphone=
ssh_tunnel_passphrase=
gateway_server=
disableautoreconnect=0
ssh_tunnel_username=
glyph-cache=0
serialpermissive=0
network=none
ssh_tunnel_certfile=
execpath=
multitransport=0
rdp2tcp=
multimon=0
audio-output=
cert_ignore=0
exec=
monitorids=
span=0
pth=
freerdp_log_filters=
parallelpath=
notes_text=
printer_overrides=
timeout=
disable-smooth-scrolling=0
serialdriver=
precommand=
server=
useproxyenv=0
colordepth=99
gateway_domain=
shareparallel=0
viewmode=4
EOF

#Libre Office
apt-get install -y libreoffice
# Desktop icon
sed -i "s@Exec=libreoffice@Exec=env LD_LIBRARY_PATH=:/usr/lib/libreoffice/program:/usr/lib/$(arch)-linux-gnu/ libreoffice@g" /usr/share/applications/libreoffice-*.desktop
cp /usr/share/applications/libreoffice-startcenter.desktop /home/kasm-user/Desktop/
chown 1000:1000 /home/kasm-user/Desktop/libreoffice-startcenter.desktop
chmod +x /home/kasm-user/Desktop/libreoffice-startcenter.desktop

#Tor Browser
apt-get install -y xz-utils curl
TOR_HOME=/home/kasm-user/tor-browser/
mkdir -p $TOR_HOME
if [ "$(arch)" == "aarch64" ]; then
  SF_VERSION=$(curl -sI https://sourceforge.net/projects/tor-browser-ports/files/latest/download | awk -F'(ports/|/tor)' '/location/ {print $3}')
  FULL_TOR_URL="https://downloads.sourceforge.net/project/tor-browser-ports/${SF_VERSION}/tor-browser-linux-arm64-${SF_VERSION}.tar.xz"
else
  TOR_URL=$(curl -q https://www.torproject.org/download/ | grep downloadLink | grep linux | sed 's/.*href="//g'  | cut -d '"' -f1 | head -1)
  FULL_TOR_URL="https://www.torproject.org/${TOR_URL}"
fi
wget --quiet "${FULL_TOR_URL}" -O /tmp/torbrowser.tar.xz
tar -xJf /tmp/torbrowser.tar.xz -C $TOR_HOME
rm /tmp/torbrowser.tar.xz
cp $TOR_HOME/tor-browser/start-tor-browser.desktop $TOR_HOME/tor-browser/start-tor-browser.desktop.bak
cp $TOR_HOME/tor-browser/Browser/browser/chrome/icons/default/default128.png /usr/share/icons/tor.png
chown 1000:0 /usr/share/icons/tor.png
sed -i 's/^Name=.*/Name=Tor Browser/g' $TOR_HOME/tor-browser/start-tor-browser.desktop
sed -i 's/Icon=.*/Icon=\/usr\/share\/icons\/tor.png/g' $TOR_HOME/tor-browser/start-tor-browser.desktop
#sed -i 's/Exec=.*/Exec=sh -c \x27"/home/kasm-user\/tor-browser\/tor-browser\/Browser\/start-tor-browser" --detach || ([ !  -x "/home/kasm-user\/tor-browser\/tor-browser\/Browser\/start-tor-browser" ] \&\& "$(dirname "$*")"\/Browser\/start-tor-browser --detach)\x27 dummy %k/g'  $TOR_HOME/tor-browser/start-tor-browser.desktop
cat >> $TOR_HOME/tor-browser/Browser/TorBrowser/Data/Browser/profile.default/prefs.js <<EOL
user_pref("app.update.download.promptMaxAttempts", 0);
user_pref("app.update.elevation.promptMaxAttempts", 0);
user_pref("app.update.checkInstallTime", false);
user_pref("app.update.background.interval", 315360000);
user_pref("extensions.torlauncher.prompt_at_startup", false);
user_pref("extensions.torlauncher.quickstart", true);
user_pref("browser.download.lastDir", "/home/kasm-user/Downloads");
user_pref("torbrowser.settings.bridges.builtin_type", "");
user_pref("torbrowser.settings.bridges.enabled", false);
user_pref("torbrowser.settings.bridges.source", -1);
user_pref("torbrowser.settings.enabled", true);
user_pref("torbrowser.settings.firewall.enabled", false);
user_pref("torbrowser.settings.proxy.enabled", false);
user_pref("torbrowser.settings.quickstart.enabled", true);
EOL
# Maintain backwards compatability with old image definitions that expect tor to be launched from /tmp
mkdir -p /tmp/tor-browser/Browser/
ln -s $TOR_HOME/tor-browser/start-tor-browser.desktop /tmp/tor-browser/Browser/start-tor-browser.desktop 
chown -R 1000:0 $TOR_HOME/
cp $TOR_HOME/tor-browser/start-tor-browser.desktop /home/kasm-user/Desktop/

install_external_package() {
  API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "amd64\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling %s ..." "${PROJECT}"
    TEMP_DEB="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_DEB}" "${DL_URL}"
    chmod 644 "${TEMP_DEB}"
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    printf " done"
  }
}

install_go() {
  curl --silent --location --output /tmp/go.tgz \
       https://go.dev/dl/go1.23.5.linux-amd64.tar.gz
  [ -d /usr/local ] || mkdir -p /usr/local
  tar -C /usr/local -xf /tmp/go.tgz
  rm -f /tmp/go.tgz
}

install_lsd() {
  API_URL="https://api.github.com/repos/lsd-rs/lsd/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "lsd_" | grep "_amd64\.deb")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling LSD ..."
    TEMP_DEB="$(mktemp --suffix=.deb)"
    wget --quiet -O "${TEMP_DEB}" "${DL_URL}"
    chmod 644 "${TEMP_DEB}"
    apt-get install -y "${TEMP_DEB}"
    rm -f "${TEMP_DEB}"
    printf " done"
  }
}

install_obs() {
  API_URL="https://api.github.com/repos/Yakitrak/obsidian-cli/releases/latest"
  DL_URL=
  DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
    | jq --raw-output '.assets | .[]?.browser_download_url' \
    | grep "obsidian-cli" | grep "linux_amd64\.tar\.gz")

  [ "${DL_URL}" ] && {
    printf "\n\tInstalling OBS ..."
    TEMP_TGZ="$(mktemp --suffix=.tgz)"
    wget --quiet -O "${TEMP_TGZ}" "${DL_URL}"
    chmod 644 "${TEMP_TGZ}"
    [ -d /usr/local ] || mkdir -p /usr/local
    [ -d /usr/local/bin ] || mkdir -p /usr/local/bin
    tar -C /usr/local/bin -xf "${TEMP_TGZ}"
    rm -f "${TEMP_TGZ}" /usr/local/bin/LICENSE /usr/local/bin/README.md
    # We run through hoops because the maintainer has not changed the name of
    # the command even though it conflicts with OBS Studio but he might do so.
    # We need it to be 'obs-cli'
    if [ -f /usr/local/bin/obs ]; then
      mv /usr/local/bin/obs /usr/local/bin/obs-cli
      chmod 755 /usr/local/bin/obs-cli
    else
      if [ -f /usr/local/bin/obs-cli ]; then
        chmod 755 /usr/local/bin/obs-cli
      else
        for cli in /usr/local/bin/obs*
        do
          [ "${cli}" == "/usr/local/bin/obs*" ] && continue
          ln -s "${cli}" /usr/local/bin/obs-cli
          break
        done
      fi
    fi
    printf " done"
  }
}

# GH_TOKEN, a GitHub token must be set in the environment
# If it is not already set then the convenience build script will set it
if [ "${GH_TOKEN}" ]; then
  export GH_TOKEN="${GH_TOKEN}"
else
  export GH_TOKEN="__GITHUB_API_TOKEN__"
fi
# Check to make sure
echo "${GH_TOKEN}" | grep __GITHUB_API | grep __TOKEN__ > /dev/null && {
  # It didn't get set right, unset it
  export GH_TOKEN=
}

if [ "${GH_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GH_TOKEN}\""
else
  AUTH_HEADER=
fi

install_go
install_lsd
install_obs

PROJECT=btop
install_external_package
PROJECT=cbftp
install_external_package
OWNER=obsidianmd
PROJECT=obsidian-releases
install_external_package

FIGLET_DIR="/usr/share/figlet-fonts"
FIGLET_ZIP="figlet-fonts.zip"
zip_inst=$(type -p zip)
if [ "${zip_inst}" ]; then
  pyfig_inst=$(type -p pyfiglet)
  [ "${pyfig_inst}" ] || {
    python3 -m pip install pyfiglet
    pyfig_inst=$(type -p pyfiglet)
  }
  if [ "${pyfig_inst}" ]; then
    PYFIG=$(command -v pyfiglet)
    ZIP=$(command -v zip)
    if [ -d ${FIGLET_DIR} ]; then
      cd ${FIGLET_DIR} || echo "Could not enter ${FIGLET_DIR}"
      ${ZIP} -q ${FIGLET_ZIP} ./*.flf
      ${PYFIG} -L ${FIGLET_ZIP}
      rm -f ${FIGLET_ZIP}
    fi
  fi
fi

#setup desktop
mkdir /home/kasm-user/.local/share/backgrounds
rm -rf /home/kasm-user/.mozilla && \
bash /home/kasm-user/workspaces-images/src/ubuntu/install/install_kasm_user.sh noble && \
/dockerstartup/set_user_permission.sh /home/kasm-user && \
rm -f /etc/X11/xinit/Xclients && \
cp /usr/share/backgrounds/Earth-Galaxy-Space.png /home/kasm-user/.local/share/backgrounds/bg_default.png && \
rm -f /usr/share/extra/backgrounds/bg_default.png && \
ln -s /home/kasm-user/.local/share/backgrounds/bg_default.png \
      /usr/share/extra/backgrounds/bg_default.png && \
chown 1000:1000 /home/kasm-user && \
mkdir -p /home/kasm-user && \
chown -R 1000:1000 /home/kasm-user && \
chsh -s /bin/zsh kasm-user

chown -R 1000:1000 /home/kasm-user