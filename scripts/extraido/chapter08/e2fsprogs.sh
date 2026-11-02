# ---- [userinput]
mkdir -v build
cd       build
# ---- [userinput]
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
# ---- [userinput]
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
# ---- [userinput]
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
# ---- [userinput]
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
# ---- [userinput]
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf
