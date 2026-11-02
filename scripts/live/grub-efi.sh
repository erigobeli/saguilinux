# H11a - GRUB 2.12 com alvo x86_64-efi (o cap. 8 gera só i386-pc). Mesmo pacote do livro, outra plataforma.
# BLFS 12.4 GRUB-2.12 for EFI: Unifont + FreeType para gerar unicode.pf2 e grub-mkfont
mkdir -pv /usr/share/fonts/unifont
gunzip -c ../unifont-16.0.04.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
unset {C,CPP,CXX,LD}FLAGS
echo depends bli part_gpt > grub-core/extra_deps.lst
./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-efiemu    \
            --with-platform=efi \
            --target=x86_64     \
            --disable-werror
make
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions || true
ls -d /usr/lib/grub/i386-pc /usr/lib/grub/x86_64-efi
ls -l /usr/share/grub/unicode.pf2 /usr/bin/grub-mkfont
