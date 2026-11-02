# ---- [userinput]
mkdir -p build
cd       build

meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false
# ---- [userinput]
ninja
# ---- [userinput]
ninja install
