# ---- [userinput]
make mrproper
# ---- [userinput]
make menuconfig
# ---- [userinput]
make
# ---- [userinput]
make modules_install
# ---- [userinput]
mount /boot
# ---- [userinput]
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.16.1-lfs-12.4
# ---- [userinput]
cp -iv System.map /boot/System.map-6.16.1
# ---- [userinput]
cp -iv .config /boot/config-6.16.1
# ---- [userinput]
cp -r Documentation -T /usr/share/doc/linux-6.16.1
# ---- [userinput]
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
