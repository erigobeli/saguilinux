# ---- [userinput]
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
chown -R tester .
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak
# ---- [userinput]
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
   &> vim-test.log
# ---- [userinput]
make install
# ---- [userinput]
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
# ---- [userinput]
ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.1629
# ---- [userinput]
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
# ---- [userinput]
vim -c ':options'
