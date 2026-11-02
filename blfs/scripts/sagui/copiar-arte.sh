# Copia a arte do projeto para /sources/sagui-arte do $LFS (usada pelo kernel e pela integração)
P=/home/erigobeli/distro-ai/blfs
mkdir -p $LFS/sources/sagui-arte
cp -v $P/arte/{logo_linux_clut224.ppm,wallpaper-sagui.png,mascote-sagui.svg,logo-sagui.svg,bemvindo.html} $P/arte/logo-{16,24,32,48,64,128,256}.png $LFS/sources/sagui-arte/
