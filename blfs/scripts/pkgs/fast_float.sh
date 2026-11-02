# REVISADO — general/fast_float — fast_float-8.0.2
set -e
mkdir build &&
cd    build &&

cmake -D CMAKE_INSTALL_PREFIX=/usr \
      -D CMAKE_BUILD_TYPE=Release  \
      -G Ninja ..
ninja install
