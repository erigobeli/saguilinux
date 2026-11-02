# REVISADO — x/mesa — Mesa-25.1.8
set -e
patch -Np1 -i ../mesa-add_xdemos-4.patch
# DESVIO: só X11; drivers explícitos (iris exige libclc, fora do escopo); sem Vulkan; sem codecs de vídeo patenteados
mkdir build
cd    build
meson setup ..                 \
      --prefix=$XORG_PREFIX    \
      --buildtype=release      \
      -D platforms=x11         \
      -D gallium-drivers=llvmpipe,softpipe,crocus,i915,nouveau,r300,r600,radeonsi,svga,virgl \
      -D vulkan-drivers=""     \
      -D valgrind=disabled     \
      -D libunwind=disabled
ninja
ninja install
