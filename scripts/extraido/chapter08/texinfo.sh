# ---- [userinput]
sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm
# ---- [userinput]
./configure --prefix=/usr
# ---- [userinput]
make
# ---- [userinput]
make check
# ---- [userinput]
make install
# ---- [userinput]
make TEXMF=/usr/share/texmf install-tex
# ---- [userinput]
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
