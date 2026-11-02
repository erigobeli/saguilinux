# REVISADO — general/cmake — CMake-4.1.0
set -e
# DESVIO: sem --system-libs (curl/libarchive/libuv/nghttp2 ainda não instalados); usa as cópias embutidas do CMake
sed -i '/"lib64"/s/64//' Modules/GNUInstallDirs.cmake
./bootstrap --prefix=/usr --mandir=/share/man --docdir=/share/doc/cmake-4.1.0 --parallel=$(nproc)
make
make install
