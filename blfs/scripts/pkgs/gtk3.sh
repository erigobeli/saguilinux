# REVISADO — x/gtk3 — GTK-3.24.50
set -e
# DESVIO: só backend X11 (sem Wayland/broadway), sem páginas de manual (docbook)
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D man=false -D broadway_backend=false -D wayland_backend=false
ninja
ninja install
gtk-query-immodules-3.0 --update-cache
glib-compile-schemas /usr/share/glib-2.0/schemas
