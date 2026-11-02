# REVISADO — general/glib2 — GLib-2.84.4
set -e
patch -Np1 -i ../glib-skip_warnings-1.patch
if [ -e /usr/include/glib-2.0 ]; then
    rm -rf /usr/include/glib-2.0.old &&
    mv -vf /usr/include/glib-2.0{,.old}
fi
# DESVIO: sem páginas de manual (exigiriam libxslt/DocBook)
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D introspection=disabled -D glib_debug=disabled -D man-pages=disabled -D sysprof=disabled
ninja
ninja install
tar xf ../../gobject-introspection-1.84.0.tar.xz &&

meson setup gobject-introspection-1.84.0 gi-build \
            --prefix=/usr --buildtype=release     &&
ninja -C gi-build
ninja -C gi-build install
meson configure -D introspection=enabled &&
ninja
ninja install
