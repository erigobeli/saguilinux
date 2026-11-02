# ---- [userinput]
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
# ---- [userinput]
make NETNS_RUN_DIR=/run/netns
# ---- [userinput]
make SBINDIR=/usr/sbin install
# ---- [userinput]
install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.16.0
