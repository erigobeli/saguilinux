# REVISADO — postlfs/mousepad — mousepad-0.6.5
set -e
mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release &&

ninja
ninja install

# ---------------- B08 Firefox ----------------
