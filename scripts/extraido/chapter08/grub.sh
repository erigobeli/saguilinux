# ---- [userinput]
unset {C,CPP,CXX,LD}FLAGS
# ---- [userinput]
echo depends bli part_gpt > grub-core/extra_deps.lst
# ---- [userinput]
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror
# ---- [userinput]
make
# ---- [userinput]
make install
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions
