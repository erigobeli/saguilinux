# H09 - Kernel 6.16.1 (livro cap. 10.3) com drivers EMBUTIDOS para VM e hardware real (PRD seção 6).
# 'make menuconfig' (interativo) é substituído por defconfig + scripts/config + olddefconfig.
make mrproper
make defconfig
Y="WERROR=n PSI=y PSI_DEFAULT_DISABLED=n IKHEADERS=n CGROUPS=y MEMCG=y EXPERT=n
RELOCATABLE=y RANDOMIZE_BASE=y STACKPROTECTOR=y STACKPROTECTOR_STRONG=y
UEVENT_HELPER=n DEVTMPFS=y DEVTMPFS_MOUNT=y
SYSFB_SIMPLEFB=y DRM=y DRM_PANIC=y DRM_FBDEV_EMULATION=y DRM_SIMPLEDRM=y FRAMEBUFFER_CONSOLE=y
X86_X2APIC=y PCI=y PCI_MSI=y IOMMU_SUPPORT=y IRQ_REMAP=y
BLK_DEV_INITRD=y RD_GZIP=y RD_XZ=y RD_ZSTD=y
ISO9660_FS=y JOLIET=y ZISOFS=y SQUASHFS=y SQUASHFS_XZ=y SQUASHFS_ZSTD=y SQUASHFS_FILE_DIRECT=y
OVERLAY_FS=y TMPFS=y TMPFS_POSIX_ACL=y EXT4_FS=y FAT_FS=y VFAT_FS=y MSDOS_FS=y
NLS=y NLS_CODEPAGE_437=y NLS_ISO8859_1=y NLS_UTF8=y BLK_DEV_LOOP=y
USB_SUPPORT=y USB=y USB_PCI=y USB_XHCI_HCD=y USB_XHCI_PCI=y USB_EHCI_HCD=y USB_EHCI_PCI=y USB_OHCI_HCD=y USB_OHCI_HCD_PCI=y USB_UHCI_HCD=y
USB_STORAGE=y USB_UAS=y HID=y HID_GENERIC=y USB_HID=y
SCSI=y BLK_DEV_SD=y BLK_DEV_SR=y ATA=y SATA_AHCI=y ATA_PIIX=y BLK_DEV_NVME=y
VIRTIO=y VIRTIO_MENU=y VIRTIO_PCI=y VIRTIO_BLK=y VIRTIO_NET=y SCSI_VIRTIO=y VIRTIO_CONSOLE=y
NETDEVICES=y ETHERNET=y NET_VENDOR_INTEL=y E1000=y E1000E=y IGB=y NET_VENDOR_REALTEK=y R8169=y
EFI=y EFI_STUB=y EFI_PARTITION=y FB=y FB_EFI=y FB_VESA=y
SERIAL_8250=y SERIAL_8250_CONSOLE=y SERIAL_8250_PCI=y
INPUT_KEYBOARD=y KEYBOARD_ATKBD=y"
for kv in $Y; do
  k=${kv%%=*}; v=${kv##*=}
  if [ "$v" = y ]; then scripts/config --enable $k; else scripts/config --disable $k; fi
done
scripts/config --set-str LOCALVERSION "-semente"
make olddefconfig
# Verificação: tudo que foi pedido como =y precisa estar =y no .config final
falta=0
for kv in $Y; do
  k=${kv%%=*}; v=${kv##*=}
  if [ "$v" = y ] && ! grep -q "^CONFIG_$k=y" .config; then echo "FALTA: CONFIG_$k"; falta=1; fi
done
[ $falta = 0 ] || { echo "### opções obrigatórias ausentes"; exit 1; }
echo "### KCONFIG OK"
make
make INSTALL_MOD_STRIP=1 modules_install
mkdir -pv /boot
cp -v arch/x86/boot/bzImage /boot/vmlinuz-6.16.1-semente
cp -v System.map /boot/System.map-6.16.1
cp -v .config /boot/config-6.16.1
install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOT"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOT
