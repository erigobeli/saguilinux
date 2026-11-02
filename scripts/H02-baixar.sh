#!/bin/bash
# H02: baixa todos os pacotes/patches do LFS 12.4 (SysVinit) e valida md5.
# Idempotente: wget --continue não rebaixa o que já está completo.
set -u
cd "$(dirname "$0")/../sources"
wget --no-verbose --continue --tries=3 --timeout=60 --input-file=../livro/wget-list-sysv --directory-prefix=. 2>&1
cp -n ../livro/lfs-bootscripts-20250827.tar.xz . 2>/dev/null || true
cp ../livro/md5sums .
md5sum -c md5sums 2>&1 | grep -v ': OK$'
echo "FALHAS: $(md5sum -c md5sums 2>/dev/null | grep -vc ': OK$')"
