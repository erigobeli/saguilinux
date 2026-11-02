# REVISADO — x/gtksourceview4 — gtksourceview4-4.8.4
set -e
# DESVIO: sem vala (vapi)
mkdir build
cd    build
meson setup .. --prefix=/usr --buildtype=release -D vapi=false
ninja
ninja install
