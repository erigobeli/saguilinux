# H08 - Configuração do sistema (livro cap. 9, 10.2 e 11.1), adaptada para live (ver docs/decisoes.md)
# 9.2 bootscripts (rodando dentro de lfs-bootscripts-20250827)
make install
# 9.5 rede: sem DHCP no LFS (dhcpcd é BLFS). Só loopback ativo; modelo estático deixado desligado.
cat > /etc/sysconfig/ifconfig.eth0 << "EOT"
ONBOOT=no
IFACE=eth0
SERVICE=ipv4-static
IP=10.0.2.15
GATEWAY=10.0.2.2
PREFIX=24
BROADCAST=10.0.2.255
EOT
cat > /etc/resolv.conf << "EOT"
# Begin /etc/resolv.conf
nameserver 1.1.1.1
nameserver 8.8.8.8
# End /etc/resolv.conf
EOT
echo "semente" > /etc/hostname
cat > /etc/hosts << "EOT"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost
127.0.1.1 semente.localdomain semente
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# End /etc/hosts
EOT
# 9.6 inittab: runlevel 3 (texto), login em tty1..tty6 e no console serial ttyS0
cat > /etc/inittab << "EOT"
# Begin /etc/inittab

id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S06:once:/sbin/sulogin
s1:1:respawn:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600
S0:2345:respawn:/sbin/serial-getty

# End /etc/inittab
EOT
# getty serial só quando o kernel foi iniciado com console=ttyS0 (entrada "serial" do GRUB);
# em hardware sem porta serial evita o respawn em loop.
cat > /sbin/serial-getty << "EOT"
#!/bin/sh
if /usr/bin/grep -q 'console=ttyS0' /proc/cmdline; then
  exec /sbin/agetty --noclear -L 115200 ttyS0 vt100
fi
exec /usr/bin/sleep 2147483647
EOT
chmod 755 /sbin/serial-getty
cat > /etc/sysconfig/clock << "EOT"
# Begin /etc/sysconfig/clock

UTC=1

# Set this to any options you might need to give to hwclock,
# such as machine hardware clock type for Alphas.
CLOCKPARAMS=

# End /etc/sysconfig/clock
EOT
cat > /etc/sysconfig/console << "EOT"
# Begin /etc/sysconfig/console

UNICODE="1"
KEYMAP="br-abnt2"
FONT="Lat2-Terminus16"

# End /etc/sysconfig/console
EOT
# 9.7 locale
cat > /etc/profile << "EOT"
# Begin /etc/profile

for i in $(locale); do
  unset ${i%=*}
done

if [[ "$TERM" = linux ]]; then
  export LANG=C.UTF-8
else
  export LANG=pt_BR.UTF-8
fi

# End /etc/profile
EOT
# 9.8 inputrc
cat > /etc/inputrc << "EOT"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8-bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOT
# 9.9 shells
cat > /etc/shells << "EOT"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOT
# 10.2 fstab de live: a raiz é um overlay montado pelo initramfs (sem fsck: passno 0)
cat > /etc/fstab << "EOT"
# Begin /etc/fstab (live)

# file system  mount-point    type     options             dump  fsck
#                                                                order

overlay        /              overlay  defaults            0     0
proc           /proc          proc     nosuid,noexec,nodev 0     0
sysfs          /sys           sysfs    nosuid,noexec,nodev 0     0
devpts         /dev/pts       devpts   gid=5,mode=620      0     0
tmpfs          /run           tmpfs    defaults            0     0
devtmpfs       /dev           devtmpfs mode=0755,nosuid    0     0
tmpfs          /dev/shm       tmpfs    nosuid,nodev        0     0
cgroup2        /sys/fs/cgroup cgroup2  nosuid,noexec,nodev 0     0

# End /etc/fstab
EOT
# 11.1 identificação da distro
echo 12.4 > /etc/lfs-release
cat > /etc/lsb-release << "EOT"
DISTRIB_ID="Semente Linux"
DISTRIB_RELEASE="1.0"
DISTRIB_CODENAME="fase1"
DISTRIB_DESCRIPTION="Semente Linux 1.0 (LFS 12.4)"
EOT
cat > /etc/os-release << "EOT"
NAME="Semente Linux"
VERSION="1.0 (fase1)"
ID=semente
ID_LIKE=lfs
VERSION_ID=1.0
PRETTY_NAME="Semente Linux 1.0 (LFS 12.4, live)"
VERSION_CODENAME="fase1"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
RELEASE_TYPE="stable"
EOT
cat > /etc/issue << "EOT"
Semente Linux 1.0 (LFS 12.4) - \l

Login: root   (senha documentada em STATUS.md)

EOT
# senha do root (documentada em STATUS.md)
echo 'root:semente' | chpasswd
