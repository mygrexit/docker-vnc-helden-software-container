#!/usr/bin/env bash
### every exit != 0 fails the script
set -e
set -u

echo "Install noVNC - HTML5 based VNC viewer"
mkdir -p $NO_VNC_HOME/utils/websockify
wget -qO- https://github.com/novnc/noVNC/archive/v1.2.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME
wget -qO- https://github.com/novnc/websockify/archive/v0.9.0.tar.gz | tar xz --strip 1 -C $NO_VNC_HOME/utils/websockify
chmod +x -v $NO_VNC_HOME/utils/*.sh
## create index.html to forward automatically to `vnc_lite.html`
ln -s $NO_VNC_HOME/vnc_lite.html $NO_VNC_HOME/index.html

## Add autoscale to "true"
sed -i "s/scale',\ false)/scale',\ true)/g" $NO_VNC_HOME/vnc_lite.html
