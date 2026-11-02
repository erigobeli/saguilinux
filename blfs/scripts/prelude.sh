# Prelúdio de todo passo da Fase 2 no chroot (inserido pelo build.sh)
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"
as_root() { "$@"; }
export -f as_root
pathappend()  { local d=$1 v=${2:-PATH}; case ":${!v}:" in *":$d:"*) ;; *) export $v="${!v:+${!v}:}$d";; esac; }
pathprepend() { local d=$1 v=${2:-PATH}; case ":${!v}:" in *":$d:"*) ;; *) export $v="$d${!v:+:${!v}}";; esac; }
export -f pathappend pathprepend
[ -d /opt/rustc/bin ] && pathprepend /opt/rustc/bin PATH
export LANG=en_US.UTF-8
export _PIP_STANDALONE_CERT=/etc/pki/tls/certs/ca-bundle.crt
# instala um bootscript do BLFS: bootscript <nome>
bootscript() {
  ( cd /sources && rm -rf blfs-bootscripts-20250225 && tar xf blfs-bootscripts-20250225.tar.xz &&
    cd blfs-bootscripts-20250225 && make install-$1 && cd /sources && rm -rf blfs-bootscripts-20250225 )
}
