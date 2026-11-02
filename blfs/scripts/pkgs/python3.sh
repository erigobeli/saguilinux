# REVISADO — general/python3 — Python-3.13.7
set -e
# Recompila o Python do LFS (mesma versão/opções) agora que o SQLite existe: o Firefox precisa do módulo _sqlite3
./configure --prefix=/usr --enable-shared --with-system-expat --enable-optimizations --without-static-libpython
make
make install
python3 -c 'import sqlite3; print("sqlite3", sqlite3.sqlite_version)'
