# REVISADO — general/iso-codes — ISO Codes-4.18.0
set -e
./configure --prefix=/usr &&
make
make install LN_S='ln -sfn'
