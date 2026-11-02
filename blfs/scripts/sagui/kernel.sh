# B09 - Kernel 6.16.1 do Sagui: mesma base do H09 (Fase 1) + gráficos, som, input e logo de boot.
make mrproper
cp /boot/config-6.16.1 .config
# Logo de boot do Sagui (substitui o pinguim do framebuffer)
cp -v /sources/sagui-arte/logo_linux_clut224.ppm drivers/video/logo/logo_linux_clut224.ppm
Y="LOCALVERSION_AUTO=n LOGO=y LOGO_LINUX_CLUT224=y LOGO_LINUX_MONO=n LOGO_LINUX_VGA16=n
DRM=y DRM_KMS_HELPER=y DRM_FBDEV_EMULATION=y DRM_SIMPLEDRM=y FRAMEBUFFER_CONSOLE=y
DRM_I915=m DRM_NOUVEAU=m DRM_VIRTIO_GPU=m DRM_BOCHS=m DRM_QXL=m DRM_VMWGFX=m DRM_CIRRUS_QEMU=m DRM_AST=m DRM_MGAG200=m DRM_VBOXVIDEO=m
SOUND=y SND=y SND_HDA_INTEL=m SND_HDA_CODEC_REALTEK=m SND_HDA_CODEC_HDMI=m SND_HDA_GENERIC=m
SND_HDA_CODEC_CONEXANT=m SND_HDA_CODEC_ANALOG=m SND_HDA_CODEC_SIGMATEL=m SND_HDA_CODEC_VIA=m SND_INTEL8X0=m SND_USB_AUDIO=m SND_HDA_I915=y
INPUT_EVDEV=y INPUT_MOUSEDEV=y MOUSE_PS2=y I2C=y I2C_HID_ACPI=m HID_MULTITOUCH=m INPUT_TOUCHSCREEN=y USB_HID=y HID_GENERIC=y
BACKLIGHT_CLASS_DEVICE=y ACPI_VIDEO=m INPUT_UINPUT=m
CDROM=y BLK_DEV_SR=y FUSE_FS=m
SND_HRTIMER=m"
for kv in $Y; do
  k=${kv%%=*}; v=${kv##*=}
  case $v in y) scripts/config --enable $k ;; m) scripts/config --module $k ;; n) scripts/config --disable $k ;; esac
done
scripts/config --set-str LOCALVERSION "-sagui"
make olddefconfig
falta=0
for kv in $Y; do
  k=${kv%%=*}; v=${kv##*=}
  case $v in
    y) grep -q "^CONFIG_$k=y" .config || { echo "FALTA: CONFIG_$k=y"; falta=1; } ;;
    m) grep -qE "^CONFIG_$k=(m|y)" .config || { echo "FALTA: CONFIG_$k=m"; falta=1; } ;;
  esac
done
# As opções obrigatórias da Fase 1 continuam =y
for k in ISO9660_FS SQUASHFS OVERLAY_FS TMPFS EXT4_FS VFAT_FS USB_XHCI_HCD USB_EHCI_HCD USB_STORAGE USB_UAS SATA_AHCI BLK_DEV_NVME VIRTIO_BLK VIRTIO_NET SCSI_VIRTIO VIRTIO_PCI E1000 EFI_STUB FB_EFI FB_VESA SERIAL_8250_CONSOLE DEVTMPFS_MOUNT BLK_DEV_LOOP; do
  grep -q "^CONFIG_$k=y" .config || { echo "FALTA (fase 1): CONFIG_$k"; falta=1; }
done
[ $falta = 0 ] || exit 1
echo "### KCONFIG OK"
make
rm -rf /lib/modules/6.16.1-semente
make INSTALL_MOD_STRIP=1 modules_install
cp -v arch/x86/boot/bzImage /boot/vmlinuz-6.16.1-sagui
cp -v System.map /boot/System.map-6.16.1-sagui
cp -v .config /boot/config-6.16.1-sagui
rm -fv /boot/vmlinuz-6.16.1-semente
