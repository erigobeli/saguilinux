# REVISADO — xfce/xfce4-terminal — xfce4-terminal-1.1.5
set -e
# DESVIO: sem página de manual (exigiria DocBook-XSL)
sed -i "/subdir('doc')/d" meson.build
mkdir build &&
cd    build &&

meson setup ..      \
      --prefix=/usr \
      --buildtype=release &&
ninja
ninja install
