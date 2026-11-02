# B10 - Integração do Sagui Linux 2.0 (roda no chroot; arte em /sources/sagui-arte)
A=/sources/sagui-arte

# ---------- identidade ----------
echo "sagui" > /etc/hostname
cat > /etc/hosts << "EOF"
127.0.0.1 localhost.localdomain localhost
127.0.1.1 sagui.localdomain sagui
::1       localhost ip6-localhost ip6-loopback
EOF
cat > /etc/os-release << "EOF"
NAME="Sagui Linux"
VERSION="2.0 (mico)"
ID=sagui
ID_LIKE=lfs
VERSION_ID=2.0
PRETTY_NAME="Sagui Linux 2.0 (XFCE, LFS 12.4 + BLFS 12.4)"
VERSION_CODENAME="mico"
ANSI_COLOR="0;32"
LOGO=sagui-logo
HOME_URL="https://www.linuxfromscratch.org/"
RELEASE_TYPE="stable"
EOF
cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Sagui Linux"
DISTRIB_RELEASE="2.0"
DISTRIB_CODENAME="mico"
DISTRIB_DESCRIPTION="Sagui Linux 2.0 (XFCE)"
EOF
cat > /etc/issue << "EOF"
[0;32m   ____                    _
  / ___|  __ _  __ _ _   _(_)   [1;33mSagui Linux 2.0[0;32m
  \___ \ / _` |/ _` | | | | |   [0;34mXFCE · LFS 12.4 + BLFS 12.4[0;32m
   ___) | (_| | (_| | |_| | |
  |____/ \__,_|\__, |\__,_|_|
               |___/[0m
 \l   ·   usuário: sagui / senha: sagui   ·   root / sagui

EOF

# ---------- usuários ----------
mkdir -p /etc/skel
echo 'root:sagui' | chpasswd
id sagui >/dev/null 2>&1 || useradd -m -s /bin/bash -G wheel,audio,video,input,users sagui
usermod -aG wheel,audio,video,input,users sagui
echo 'sagui:sagui' | chpasswd
# live: o usuário sagui usa sudo sem senha (desligar, instalar no disco, etc.)
cat > /etc/sudoers.d/10-sagui << "EOF"
sagui ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/10-sagui

# ---------- autologin + X ----------
# runlevel 5 (padrão): tty1 entra sozinho como sagui e abre o XFCE; runlevel 3: login em texto
sed -i 's/^id:[0-9]:initdefault:/id:5:initdefault:/' /etc/inittab
sed -i '/^1:2345:respawn/d;/^t1:234:/d;/^1:5:/d' /etc/inittab
sed -i '/^2:2345:respawn/i 1:5:respawn:/sbin/agetty --noclear --autologin sagui tty1 9600\nt1:234:respawn:/sbin/agetty --noclear tty1 9600' /etc/inittab
[ -d /etc/rc.d/rc5.d ] || cp -a /etc/rc.d/rc3.d /etc/rc.d/rc5.d
cat > /etc/skel/.bash_profile << "EOF"
# Sagui Linux: no tty1 abre o XFCE automaticamente (exceto em modo texto)
[ -f ~/.bashrc ] && . ~/.bashrc
if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ] && ! grep -qw sagui.texto /proc/cmdline; then
  mkdir -p ~/.cache
  startx -- -keeptty > ~/.cache/xsession.log 2>&1
  echo "A sessão gráfica terminou. Log: ~/.cache/xsession.log  (para voltar ao XFCE: startx)"
fi
EOF
cat > /etc/skel/.bashrc << "EOF"
export LANG=pt_BR.UTF-8
PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
EOF
cat > /etc/skel/.xinitrc << "EOF"
export LANG=pt_BR.UTF-8
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_DIRS=/usr/local/share:/usr/share
exec dbus-launch --exit-with-session startxfce4
EOF
mkdir -p /etc/skel/.cache
cat > /etc/X11/xorg.conf.d/00-teclado.conf << "EOF"
Section "InputClass"
    Identifier "teclado-brasil"
    MatchIsKeyboard "on"
    Option "XkbLayout" "br"
    Option "XkbModel" "abnt2"
EndSection
EOF
# Xorg sem elogind: o wrapper suid permite que o usuário abra o X no console
cat > /etc/X11/Xwrapper.config << "EOF"
allowed_users=console
needs_root_rights=yes
EOF

# ---------- rede (DHCP em todas as interfaces cabeadas) ----------
cat > /etc/rc.d/init.d/sagui-rede << "EOF"
#!/bin/sh
### BEGIN INIT INFO
# Provides:            sagui-rede
# Required-Start:      $local_fs localnet
# Default-Start:       2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:   DHCP automático (dhcpcd) em todas as interfaces
### END INIT INFO
. /lib/lsb/init-functions
case "$1" in
  start) log_info_msg "Iniciando DHCP (dhcpcd)..."; /usr/sbin/dhcpcd -b -q >/dev/null 2>&1; evaluate_retval ;;
  stop)  log_info_msg "Parando DHCP..."; /usr/sbin/dhcpcd -x >/dev/null 2>&1; evaluate_retval ;;
  *) echo "Uso: $0 {start|stop}"; exit 1 ;;
esac
EOF
chmod 754 /etc/rc.d/init.d/sagui-rede
for r in 2 3 4 5; do ln -sfv ../init.d/sagui-rede /etc/rc.d/rc$r.d/S21sagui-rede; done
for r in 0 1 6; do ln -sfv ../init.d/sagui-rede /etc/rc.d/rc$r.d/K79sagui-rede; done
# D-Bus de sistema também em runlevel 5
for f in /etc/rc.d/rc3.d/S*dbus*; do [ -e "$f" ] && ln -sfv ../init.d/dbus /etc/rc.d/rc5.d/$(basename $f); done
# machine-id não pode ficar gravado na imagem (o bootscript do dbus gera no boot)
rm -f /var/lib/dbus/machine-id
ln -sf /var/lib/dbus/machine-id /etc/machine-id

# ---------- polkit: grupo wheel pode desligar/reiniciar/montar sem senha ----------
mkdir -p /etc/polkit-1/rules.d
cat > /etc/polkit-1/rules.d/49-sagui.rules << "EOF"
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF

# ---------- arte e tema Brasil ----------
install -dm755 /usr/share/backgrounds/sagui /usr/share/sagui
install -m644 $A/wallpaper-sagui.png /usr/share/backgrounds/sagui/
install -m644 $A/mascote-sagui.svg $A/logo-sagui.svg /usr/share/sagui/
install -Dm644 $A/logo-sagui.svg /usr/share/icons/hicolor/scalable/apps/sagui-logo.svg
for s in 16 24 32 48 64 128 256; do
  install -Dm644 $A/logo-$s.png /usr/share/icons/hicolor/${s}x${s}/apps/sagui-logo.png
done
install -Dm644 $A/mascote-sagui.svg /usr/share/icons/hicolor/scalable/apps/sagui-mascote.svg
gtk-update-icon-cache -qf /usr/share/icons/hicolor || true
gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2 || true
# O xfdesktop usa este arquivo como fundo padrão: aponta para o wallpaper do Sagui
for f in /usr/share/backgrounds/xfce/xfce-shapes.svg /usr/share/backgrounds/xfce/xfce-x.svg /usr/share/backgrounds/xfce/xfce-verticals.png; do
  [ -e "$f" ] && mv -f "$f" "$f.orig" || true
done
mkdir -p /usr/share/backgrounds/xfce
ln -sf /usr/share/backgrounds/sagui/wallpaper-sagui.png /usr/share/backgrounds/xfce/xfce-shapes.svg
ln -sf /usr/share/backgrounds/sagui/wallpaper-sagui.png /usr/share/backgrounds/xfce/xfce-x.svg
ln -sf /usr/share/backgrounds/sagui/wallpaper-sagui.png /usr/share/backgrounds/xfce/xfce-verticals.png
install -m644 $A/bemvindo.html /usr/share/sagui/bemvindo.html

# Configuração do XFCE (xfconf). Os XMLs padrão do sistema (xfce4-session.xml, xsettings.xml) ficam
# como o XFCE instalou (restaurados dos tarballs); as preferências do Sagui vão para a config do usuário
# (/etc/skel) — o xfconf combina as duas. Sobrescrever o xfce4-session.xml do sistema apaga a sessão Failsafe.
S=/etc/xdg/xfce4/xfconf/xfce-perchannel-xml
mkdir -p $S
tar -xjf /sources/xfce4-session-4.20.3.tar.bz2 -O xfce4-session-4.20.3/settings/xfce4-session.xml > $S/xfce4-session.xml
tar -xjf /sources/xfce4-settings-4.20.2.tar.bz2 -O xfce4-settings-4.20.2/xfsettingsd/xsettings.xml > $S/xsettings.xml
grep -q Failsafe $S/xfce4-session.xml
rm -f $S/xfwm4.xml $S/keyboard-layout.xml
X=/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
mkdir -p $X
cat > $X/xsettings.xml << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Adwaita"/>
    <property name="IconThemeName" type="string" value="nuoveXT2"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="FontName" type="string" value="DejaVu Sans 10"/>
    <property name="MonospaceFontName" type="string" value="DejaVu Sans Mono 10"/>
    <property name="CursorThemeName" type="string" value="whiteglass"/>
  </property>
  <property name="Xft" type="empty">
    <property name="Antialias" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
</channel>
EOF
cat > $X/keyboard-layout.xml << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="keyboard-layout" version="1.0">
  <property name="Default" type="empty">
    <property name="XkbDisable" type="bool" value="false"/>
    <property name="XkbLayout" type="string" value="br"/>
    <property name="XkbVariant" type="string" value=""/>
    <property name="XkbModel" type="string" value="abnt2"/>
  </property>
</channel>
EOF
cat > $X/xfwm4.xml << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Default"/>
    <property name="title_font" type="string" value="DejaVu Sans Bold 10"/>
    <property name="workspace_count" type="int" value="2"/>
    <property name="use_compositing" type="bool" value="false"/>
  </property>
</channel>
EOF
cat > $X/xfce4-session.xml << "EOF"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-session" version="1.0">
  <property name="general" type="empty">
    <property name="SaveOnExit" type="bool" value="false"/>
  </property>
  <property name="shutdown" type="empty">
    <property name="LockScreen" type="bool" value="false"/>
  </property>
</channel>
EOF
# Painel: botão do menu com o logo do Sagui; a config vai também para o skel para não abrir o diálogo de 1º uso
P=/etc/xdg/xfce4/panel/default.xml
if [ -f $P ]; then
  python3 - "$P" << "EOF"
import sys, re
p = sys.argv[1]; s = open(p).read()
s = re.sub(r'(<property name="plugin-1" type="string" value="applicationsmenu")\s*/>',
           r'\1>\n      <property name="button-icon" type="string" value="sagui-logo"/>\n      <property name="button-title" type="string" value="Sagui"/>\n      <property name="show-button-title" type="bool" value="true"/>\n    </property>', s)
open(p, 'w').write(s)
EOF
  mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml
  cp $P /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
fi
# GTK: cores do Brasil (verde/amarelo/azul) por cima do Adwaita
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/gtk.css << "EOF"
/* Sagui Linux: acentos com as cores do Brasil */
@define-color theme_selected_bg_color #009c3b;
@define-color theme_selected_fg_color #ffffff;
@define-color accent_color #009c3b;
.xfce4-panel.background, #XfcePanelWindow { background-color: #002776; color: #ffffff; }
#XfcePanelWindow button:hover { background-color: #009c3b; }
#XfcePanelWindow button:checked { background-color: #ffdf00; color: #002776; }
selection, *:selected { background-color: #009c3b; color: #ffffff; }
progressbar progress, scale highlight, switch:checked { background-color: #009c3b; border-color: #007a2e; }
EOF
cat > /etc/skel/.config/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = nuoveXT2
gtk-font-name = DejaVu Sans 10
EOF
# Firefox: página inicial local de boas-vindas
install -dm755 /usr/lib/firefox/distribution
cat > /usr/lib/firefox/distribution/policies.json << "EOF"
{ "policies": {
    "DisableAppUpdate": true,
    "DisableTelemetry": true,
    "OverrideFirstRunPage": "",
    "Homepage": { "URL": "file:///usr/share/sagui/bemvindo.html", "Locked": false, "StartPage": "homepage" }
} }
EOF
# Atalhos na área de trabalho do usuário
mkdir -p /etc/skel/Desktop
for app in firefox xfce4-terminal-emulator thunar mousepad; do
  for f in /usr/share/applications/$app.desktop /usr/share/applications/org.xfce.$app.desktop; do
    [ -f "$f" ] && install -m755 "$f" /etc/skel/Desktop/
  done
done
# recria o usuário sagui a partir do skel atualizado
rm -rf /home/sagui && cp -a /etc/skel /home/sagui && chown -R sagui:sagui /home/sagui
# Ajustes finais de caches
update-desktop-database /usr/share/applications || true
update-mime-database /usr/share/mime || true
glib-compile-schemas /usr/share/glib-2.0/schemas || true
fc-cache -f || true
gdk-pixbuf-query-loaders --update-cache || true
ldconfig
# instalar-no-disco (herdado da Fase 1): nomes do Sagui
sed -i -e 's/Semente Linux 1.0/Sagui Linux 2.0/g' -e 's|Login: root / semente (troque com passwd).|Login automático: sagui (senha sagui); root/sagui.|' \
       -e 's/(LFS 12.4, live)/(XFCE, LFS 12.4 + BLFS 12.4)/' -e 's/-L SEMENTE /-L SAGUI /' /usr/sbin/instalar-no-disco
